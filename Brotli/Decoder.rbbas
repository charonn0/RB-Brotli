#tag Class
Protected Class Decoder
	#tag Method, Flags = &h0
		Sub Constructor()
		  If Not Brotli.IsAvailable Then Raise New PlatformNotSupportedException
		  mState = BrotliDecoderCreateInstance(Nil, Nil, Nil)
		  If mState = Nil Then Raise New BrotliException(Me)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Destructor()
		  If mState <> Nil Then BrotliDecoderDestroyInstance(mState)
		  mState = Nil
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Perform(ReadFrom As Readable, WriteTo As Writeable, ReadCount As Integer = -1) As Boolean
		  If mState = Nil Then Return False
		  Dim availin, availout As UInt32
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
		        mLastResult = BrotliDecoderDecompressStream(mState, availin, nextin, availout, nextout, mTotalOut)
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
		Function SetParam(Param As Brotli.DecodeParameter, Value As UInt32) As Boolean
		  If mState = Nil Then Return False
		  Return BrotliDecoderSetParameter(mState, Param, Value) = 1
		End Function
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  If mState <> Nil Then Return BrotliDecoderIsUsed(mState) = 1
			End Get
		#tag EndGetter
		IsUsed As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  If mState <> Nil Then Return BrotliDecoderGetErrorCode(mState)
			End Get
		#tag EndGetter
		LastError As Integer
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

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  If mState <> Nil Then Return BrotliDecoderHasMoreOutput(mState) = 1
			End Get
		#tag EndGetter
		MoreOutputAvailable As Boolean
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mState As Ptr
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mTotalOut As UInt32
	#tag EndProperty


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
