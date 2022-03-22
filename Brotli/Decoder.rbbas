#tag Class
Protected Class Decoder
Inherits Brotli.Codec
	#tag Method, Flags = &h0
		Sub Constructor()
		  If Not Decoder.IsAvailable Then Raise New PlatformNotSupportedException
		  // Calling the overridden superclass constructor.
		  Super.Constructor(BrotliDecoderCreateInstance(Nil, Nil, Nil))
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Destructor()
		  If Me.Handle <> Nil Then BrotliDecoderDestroyInstance(Me.Handle)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function GetIsFinished() As Boolean
		  ' Returns True if the Decoder has finished.
		  
		  If Me.Handle <> Nil Then Return BrotliDecoderIsFinished(Me.Handle)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function GetMoreOutputAvailable() As Boolean
		  If Me.Handle <> Nil Then Return BrotliDecoderHasMoreOutput(Me.Handle)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function Perform(ReadFrom As Readable, WriteTo As Writeable, Operation As Brotli.Operation, ReadCount As Integer = -1) As Boolean
		  If Operation <> Brotli.Operation.Process Then Return False
		  Return Me.Perform(ReadFrom, WriteTo, ReadCount)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Perform(ReadFrom As Readable, WriteTo As Writeable, ReadCount As Integer = -1) As Boolean
		  If Me.Handle = Nil Then Return False
		  #If Target32Bit Then
		    Dim availin, availout As UInt32
		  #Else
		    Dim availin, availout As UInt64
		  #EndIf
		  Dim nextin, nextout As Ptr
		  Dim outbuff As New MemoryBlock(CHUNK_SIZE)
		  Dim count As Integer
		  
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
		        mLastResult = BrotliDecoderDecompressStream(Me.Handle, availin, nextin, availout, nextout, mTotalOut)
		      #Else
		        mLastResult = BrotliDecoderDecompressStream64(Me.Handle, availin, nextin, availout, nextout, mTotalOut64)
		      #endif
		      Dim have As UInt32 = CHUNK_SIZE - availout
		      If mLastResult = DecodeResult.Error Then Return False
		      If have > 0 Then
		        If have <> outbuff.Size Then outbuff.Size = have
		        WriteTo.Write(outbuff)
		      End If
		    Loop Until mLastResult <> DecodeResult.MoreOutputNeeded
		    
		  Loop Until (ReadCount > -1 And count >= ReadCount) Or ReadFrom = Nil Or ReadFrom.EOF Or mLastResult <> DecodeResult.MoreInputNeeded
		  
		  Return mLastResult = DecodeResult.Success Or mLastResult = DecodeResult.MoreInputNeeded
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SetParam(Param As Brotli.CodecOption, Value As UInt32) As Boolean
		  If Me.Handle = Nil Then Return False
		  If Param <> CodecOption.DisableLiteralContextModeling Then Return False ' this is the only supported decode option
		  #If Target32Bit Then
		    Return BrotliDecoderSetParameter(Me.Handle, Param, Value)
		  #Else
		    Dim value64 As UInt64 = Value
		    Return BrotliDecoderSetParameter64(Me.Handle, Param, value64)
		  #endif
		End Function
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  ' Returns True if decompression is available.
			  
			  Static available As Boolean = System.IsFunctionAvailable("BrotliDecoderCreateInstance", libbrotlidec)
			  Return available
			End Get
		#tag EndGetter
		Shared IsAvailable As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  ' Returns False if the Decoder has not processed any input yet.
			  
			  If Me.Handle <> Nil Then Return BrotliDecoderIsUsed(Me.Handle)
			End Get
		#tag EndGetter
		IsUsed As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mLastResult
			End Get
		#tag EndGetter
		LastResult As Brotli.DecodeResult
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mLastResult As Brotli.DecodeResult
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mUseRingBufferReallocation As Boolean = True
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mUseRingBufferReallocation
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If value = mUseRingBufferReallocation Then Return
			  If value Then
			    If Not SetParam(CodecOption.DisableRingBufferRealloc, 0) Then Return
			  Else
			    If Not SetParam(CodecOption.DisableRingBufferRealloc, 1) Then Return
			  End If
			  mUseRingBufferReallocation = value
			End Set
		#tag EndSetter
		UseRingBufferReallocation As Boolean
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
