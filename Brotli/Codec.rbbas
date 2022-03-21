#tag Class
Protected Class Codec
	#tag Method, Flags = &h1
		Protected Sub Constructor()
		  If Not Brotli.IsAvailable Then Raise New PlatformNotSupportedException
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function GetIsFinished() As Boolean
		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function GetLastError() As Integer
		  Return 0
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function GetMoreOutputAvailable() As Boolean
		  Return False
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Perform(ReadFrom As Readable, WriteTo As Writeable, Operation As Brotli.Operation, ReadCount As Integer = -1) As Boolean
		  #pragma Unused ReadFrom
		  #pragma Unused WriteTo
		  #pragma Unused Operation
		  #pragma Unused ReadCount
		  Return False
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SetParam(Param As Brotli.CodecOption, Value As UInt32) As Boolean
		  #pragma Unused Param
		  #pragma Unused Value
		  Return False
		End Function
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return GetIsFinished()
			End Get
		#tag EndGetter
		IsFinished As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return GetLastError()
			End Get
		#tag EndGetter
		LastError As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return GetMoreOutputAvailable()
			End Get
		#tag EndGetter
		MoreOutputAvailable As Boolean
	#tag EndComputedProperty

	#tag Property, Flags = &h1
		Protected mState As Ptr
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected mTotalOut As UInt32
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected mTotalOut64 As UInt64
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
			Name="LastError"
			Group="Behavior"
			Type="Integer"
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
