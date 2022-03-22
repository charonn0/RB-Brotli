#tag Class
Protected Class Encoder
Inherits Brotli.Codec
	#tag Method, Flags = &h0
		Sub Constructor(Quality As Int32 = Brotli.BROTLI_DEFAULT_QUALITY, SizeHint As UInt32 = 0)
		  If Not Encoder.IsAvailable Then Raise New PlatformNotSupportedException
		  // Calling the overridden superclass constructor.
		  Super.Constructor(BrotliEncoderCreateInstance(Nil, Nil, Nil))
		  If Quality <> BROTLI_DEFAULT_QUALITY Then Me.Quality = Quality
		  If SizeHint > 0 Then Call SetParam(CodecOption.SizeHint, SizeHint)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Destructor()
		  If Me.Handle <> Nil Then BrotliEncoderDestroyInstance(Me.Handle)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function GetIsFinished() As Boolean
		  ' Returns True if the Encoder has finished.
		  
		  If Me.Handle <> Nil Then Return BrotliEncoderIsFinished(Me.Handle)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function GetMoreOutputAvailable() As Boolean
		  If Me.Handle <> Nil Then Return BrotliEncoderHasMoreOutput(Me.Handle)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Perform(ReadFrom As Readable, WriteTo As Writeable, Operation As Brotli.Operation, ReadCount As Integer = - 1) As Boolean
		  If Me.Handle = Nil Then Return False
		  
		  Dim outbuff As New MemoryBlock(CHUNK_SIZE)
		  Dim count As Int32
		  Dim OK As Boolean
		  #If Target32Bit Then
		    Dim availin, availout As UInt32
		  #Else
		    Dim availin, availout As UInt64
		  #endif
		  Dim nextin, nextout As Ptr
		  
		  Do
		    Dim chunk As MemoryBlock
		    Dim sz As Integer
		    If ReadCount > -1 Then sz = Min(ReadCount - count, CHUNK_SIZE) Else sz = CHUNK_SIZE
		    If ReadFrom <> Nil And sz > 0 Then chunk = ReadFrom.Read(sz) Else chunk = ""
		    
		    availin = chunk.Size
		    nextin = chunk
		    count = count + chunk.Size
		    
		    Do
		      If outbuff.Size <> CHUNK_SIZE Then outbuff.Size = CHUNK_SIZE
		      nextout = outbuff
		      availout = outbuff.Size
		      #If Target32Bit Then
		        OK = BrotliEncoderCompressStream(Me.Handle, Operation, availin, nextin, availout, nextout, mTotalOut)
		      #Else
		        OK = BrotliEncoderCompressStream64(Me.Handle, Operation, availin, nextin, availout, nextout, mTotalOut64)
		      #endif
		      Dim have As UInt32 = CHUNK_SIZE - availout
		      If have > 0 Then
		        If have <> outbuff.Size Then outbuff.Size = have
		        WriteTo.Write(outbuff)
		      End If
		    Loop Until Not OK Or availout <> 0
		    
		  Loop Until (ReadCount > -1 And count >= ReadCount) Or ReadFrom = Nil Or ReadFrom.EOF
		  
		  Return availin = 0 And OK
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SetParam(Option As Brotli.CodecOption, Value As UInt32) As Boolean
		  Return BrotliEncoderSetParameter(Me.Handle, Option, Value)
		End Function
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Note
			Recommended input block size.
			
			Encoder may reduce this value, e.g. if input is much smaller than input block size.
			
			Range is from BROTLI_MIN_INPUT_BLOCK_BITS to BROTLI_MAX_INPUT_BLOCK_BITS.
			
			Note:
			Bigger input block size allows better compression, but consumes more memory. The rough
			formula of memory used for temporary input storage is =ShiftLeft(3, BlockSize)
		#tag EndNote
		#tag Getter
			Get
			  return mBlockSize
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If value > BROTLI_MAX_INPUT_BLOCK_BITS Or value < BROTLI_MIN_INPUT_BLOCK_BITS Then 
			    Dim err As New BrotliException(Me)
			    err.Message = "Block size is out of range."
			    Raise err
			  End If
			  If SetParam(CodecOption.LGBLOCK, value) Then mBlockSize = value
			End Set
		#tag EndSetter
		BlockSize As UInt32
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  ' Returns True if compression is available.
			  
			  Static available As Boolean = System.IsFunctionAvailable("BrotliEncoderCreateInstance", libbrotlienc)
			  Return available
			End Get
		#tag EndGetter
		Shared IsAvailable As Boolean
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mBlockSize As UInt32
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mMode As Brotli.EncoderMode
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Note
			Tune encoder for specific input.
			
			See the EncoderMode enumeration for possible values.
		#tag EndNote
		#tag Getter
			Get
			  return mMode
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If SetParam(CodecOption.Mode, CType(value, UInt32)) Then mMode = value
			End Set
		#tag EndSetter
		Mode As Brotli.EncoderMode
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mQuality As Int32 = BROTLI_DEFAULT_QUALITY
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mUseLiteralContextModeling As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mWindowSize As UInt32
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Note
			The main compression speed-density lever.
			
			The higher the quality, the slower the compression. Range is from BROTLI_MIN_QUALITY to BROTLI_MAX_QUALITY.
		#tag EndNote
		#tag Getter
			Get
			  return mQuality
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If SetParam(CodecOption.Quality, value) Then mQuality = value
			End Set
		#tag EndSetter
		Quality As Int32
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mUseLiteralContextModeling
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If value = mUseLiteralContextModeling Then Return
			  If value Then
			    If Not SetParam(CodecOption.DisableLiteralContextModeling, 0) Then Return
			  Else
			    If Not SetParam(CodecOption.DisableLiteralContextModeling, 1) Then Return
			  End If
			  mUseLiteralContextModeling = value
			End Set
		#tag EndSetter
		UseLiteralContextModeling As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  If Brotli.IsAvailable Then Return BrotliEncoderVersion()
			End Get
		#tag EndGetter
		Shared Version As UInt32
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Note
			Recommended sliding LZ77 window size.
			
			Encoder may reduce this value, e.g. if input is much smaller than window size.
			
			Window size is =ShiftLeft(1, thisValue)-16
			
			Range is from BROTLI_MIN_WINDOW_BITS to BROTLI_MAX_WINDOW_BITS.
		#tag EndNote
		#tag Getter
			Get
			  return mWindowSize
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If value > BROTLI_MAX_WINDOW_BITS Or value < BROTLI_MIN_WINDOW_BITS Then 
			    Dim err As New BrotliException(Me)
			    err.Message = "Window size is out of range."
			    Raise err
			  End If
			  If SetParam(CodecOption.LGWIN, value) Then mWindowSize = value
			End Set
		#tag EndSetter
		WindowSize As UInt32
	#tag EndComputedProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsFinished"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="MoreOutputAvailable"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			InheritedFrom="Object"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
