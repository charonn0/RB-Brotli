#tag Class
Protected Class Encoder
	#tag Method, Flags = &h21
		Private Shared Function AllocFunction(Opaque As Ptr, Size As UInt32) As Ptr
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  If Not Brotli.IsAvailable Then Raise New PlatformNotSupportedException
		  'If Instances = Nil Then Instances = New Dictionary
		  'Static lastopaque As Integer
		  'Do
		  'lastopaque = lastopaque + 1
		  'Loop Until Not Instances.HasKey(lastopaque)
		  
		  mState = BrotliEncoderCreateInstance(Nil, Nil, Nil)
		  'Brotli.Encode.BrotliEncoderCreateInstance(AddressOf AllocFunction, AddressOf FreeFunction, Ptr(lastopaque))
		  If mState = Nil Then Raise New BrotliException
		  'Instances.Value(lastopaque) = New WeakRef(Me)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Destructor()
		  If mState <> Nil Then BrotliEncoderDestroyInstance(mState)
		  mState = Nil
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Encode(ReadFrom As Readable, WriteTo As Writeable, Operation As Brotli.Operation) As Boolean
		  If mState = Nil Then Return False
		  Do
		    Dim chunk As MemoryBlock
		    If ReadFrom = Nil Then chunk = "" Else chunk = ReadFrom.Read(CHUNK_SIZE)
		    Dim out As New MemoryBlock(CHUNK_SIZE)
		    Dim availin As UInt32 = chunk.Size
		    Dim nextin As Ptr = chunk
		    Dim nextout As Ptr = out
		    Dim availout As UInt32 = out.Size
		    If Not BrotliEncoderCompressStream(mState, Operation, availin, nextin, availout, nextout, mTotalOut) Then Return False
		    WriteTo.Write(out.StringValue(0, out.Size - availout))
		  Loop Until ReadFrom = Nil Or ReadFrom.EOF
		  
		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Sub FreeFunction(Opaque As Ptr, Address As Ptr)
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private Shared Instances As Dictionary
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  If mState <> Nil Then Return BrotliEncoderHasMoreOutput(mState) = 1
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
