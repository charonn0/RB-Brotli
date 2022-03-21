#tag Class
Protected Class Encoder
Inherits Brotli.Codec
	#tag Method, Flags = &h0
		Sub Constructor(Quality As Int32 = Brotli.BROTLI_DEFAULT_QUALITY)
		  If Not Encoder.IsAvailable Then Raise New PlatformNotSupportedException
		  // Calling the overridden superclass constructor.
		  Super.Constructor(BrotliEncoderCreateInstance(Nil, Nil, Nil))
		  If Quality <> BROTLI_DEFAULT_QUALITY Then Me.Quality = Quality
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
		Private mQuality As Int32 = BROTLI_DEFAULT_QUALITY
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
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
			  If Brotli.IsAvailable Then Return BrotliEncoderVersion()
			End Get
		#tag EndGetter
		Shared Version As UInt32
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
