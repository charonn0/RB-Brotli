#tag Class
Protected Class Decoder
	#tag Method, Flags = &h21
		Private Shared Function AllocFunction(Opaque As Ptr, Size As UInt32) As Ptr
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  If Not Brotli.IsAvailable Then Raise New PlatformNotSupportedException
		  If Instances = Nil Then Instances = New Dictionary
		  Static lastopaque As Integer
		  Do
		    lastopaque = lastopaque + 1
		  Loop Until Not Instances.HasKey(lastopaque)
		  
		  mState = Brotli.Decode.BrotliDecoderCreateInstance(AddressOf AllocFunction, AddressOf FreeFunction, Ptr(lastopaque))
		  If mState = Nil Then Raise New BrotliException
		  Instances.Value(lastopaque) = New WeakRef(Me)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Decode(Input As MemoryBlock, Output As MemoryBlock) As Brotli.Decode.DecodeResult
		  If mState = Nil Then Return Brotli.Decode.DecodeResult.Error
		  
		  mAvailIn = Input.Size
		  mNextIn = Input
		  mNextOut = Output
		  mAvailOut = Output.Size
		  Return Brotli.Decode.BrotliDecoderDecompressStream(mState, mAvailIn, mNextIn, mAvailOut, mNextOut, mTotalOut)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Destructor()
		  If mState <> Nil Then Brotli.Decode.BrotliDecoderDestroyInstance(mState)
		  mState = Nil
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Sub FreeFunction(Opaque As Ptr, Address As Ptr)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function LastError() As Integer
		  If mState <> Nil Then Return Brotli.Decode.BrotliDecoderGetErrorCode(mState)
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private Shared Instances As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mAvailIn As UInt32
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mAvailOut As UInt32
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mNextIn As Ptr
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mNextOut As Ptr
	#tag EndProperty

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
