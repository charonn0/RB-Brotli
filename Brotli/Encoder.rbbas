#tag Class
Protected Class Encoder
	#tag Method, Flags = &h0
		Sub Constructor()
		  If Not Brotli.IsAvailable Then Raise New PlatformNotSupportedException
		  mState = BrotliEncoderCreateInstance(Nil, Nil, Nil)
		  If mState = Nil Then Raise New BrotliException
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Destructor()
		  If mState <> Nil Then BrotliEncoderDestroyInstance(mState)
		  mState = Nil
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Perform(ReadFrom As Readable, WriteTo As Writeable, Operation As Brotli.Operation, ReadCount As Integer = - 1) As Boolean
		  If mState = Nil Then Return False
		  
		  Dim outbuff As New MemoryBlock(CHUNK_SIZE)
		  Dim err, count As Int32
		  Dim availin, availout As UInt32
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
		      err = BrotliEncoderCompressStream(mState, Operation, availin, nextin, availout, nextout, mTotalOut)
		      Dim have As UInt32 = CHUNK_SIZE - availout
		      If have > 0 Then
		        If have <> outbuff.Size Then outbuff.Size = have
		        WriteTo.Write(outbuff)
		      End If
		    Loop Until err <> 1 Or availout <> 0
		    
		  Loop Until (ReadCount > -1 And count >= ReadCount) Or ReadFrom = Nil Or ReadFrom.EOF
		  
		  Return availin = 0 And err = 1
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SetOption(Option As Brotli.EncoderOption, Value As UInt32) As Boolean
		  Return BrotliEncoderSetParameter(mState, Option, Value) = 1
		End Function
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  If mState <> Nil Then Return BrotliEncoderIsFinished(mState) = 1
			End Get
		#tag EndGetter
		IsFinished As Boolean
	#tag EndComputedProperty

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