#tag Class
Class BrotliStream
Implements Readable,Writeable
	#tag Method, Flags = &h0
		Sub Close()
		  If mEncoder <> Nil Then
		    Try
		      Me.Flush(Operation.Finish)
		    Catch
		    End Try
		  End If
		  mSource = Nil
		  mDestination = Nil
		  mEncoder = Nil
		  mDecoder = Nil
		  mSourceMB = Nil
		  mReadBuffer = ""
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(Source As BinaryStream, Quality As Int32 = Brotli.BROTLI_DEFAULT_QUALITY)
		  ' Constructs a BrotliStream from the Source BinaryStream. If the Source's current position is equal
		  ' to its length then compressed output will be appended, otherwise the Source will be used as
		  ' input to be decompressed.
		  
		  If Source.Length = Source.Position Then 'compress into Source
		    Me.Constructor(New Encoder, Source)
		    If Quality <> BROTLI_DEFAULT_QUALITY Then Me.Quality = Quality
		  Else ' decompress from Source
		    Me.Constructor(New Decoder, Source)
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Constructor(Engine As Brotli.Decoder, Source As Readable)
		  ' Construct a decompression stream using the Engine and Source parameters
		  mDecoder = Engine
		  mSource = Source
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Constructor(Engine As Brotli.Encoder, Destination As Writeable)
		  ' Construct a compression stream using the Engine and Destination parameters
		  mEncoder = Engine
		  mDestination = Destination
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(Source As MemoryBlock, Quality As Int32 = Brotli.BROTLI_DEFAULT_QUALITY)
		  ' Constructs a BrotliStream from the Source MemoryBlock. If the Source's size is zero then
		  ' compressed output will be appended, otherwise the Source will be used as input
		  ' to be decompressed.
		  
		  If Source.Size >= 0 Then
		    Me.Constructor(New BinaryStream(Source), Quality)
		  Else
		    Raise New UnsupportedOperationException ' can't use memoryblocks of unknown size!!
		  End If
		  mSourceMB = Source
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function Create(OutputStream As FolderItem, Quality As Int32 = Brotli.BROTLI_DEFAULT_QUALITY, Overwrite As Boolean = False) As Brotli.BrotliStream
		  ' Create a compression stream where compressed output is written to the OutputStream file.
		  
		  Return Create(BinaryStream.Create(OutputStream, Overwrite), Quality)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function Create(OutputStream As Writeable, Quality As Int32 = Brotli.BROTLI_DEFAULT_QUALITY) As Brotli.BrotliStream
		  ' Create a compression stream where compressed output is written to the OutputStream object.
		  
		  Return New BrotliStream(New Encoder(Quality), OutputStream)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Destructor()
		  Me.Close()
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function EndOfFile() As Boolean
		  // Part of the Readable interface as of 2019r2
		  Return Me.EOF()
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function EOF() As Boolean
		  // Part of the Readable interface.
		  ' Returns True if there is no more output to read (decompression only)
		  Return mSource <> Nil And mSource.EOF And mDecoder <> Nil And Not mDecoder.MoreOutputAvailable And mReadBuffer = ""
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Flush() Implements Writeable.Flush
		  // Part of the Writeable interface.
		  Me.Flush(Operation.Flush)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Flush(Operation As Brotli.Operation)
		  If mEncoder = Nil Then Raise New IOException
		  If Not mEncoder.Perform(Nil, mDestination, Operation) Then Raise New BrotliException(mEncoder)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Lookahead(encoding As TextEncoding = Nil) As String
		  ' Returns the contents of the read buffer if BufferedReading is True (the default)
		  ' If there are fewer than two bytes remaining in the buffer then a new chunk is
		  ' read into the buffer.
		  
		  If Me.BufferedReading = False Then Return ""
		  If mReadBuffer.LenB < 2 Then
		    mBufferedReading = False
		    mReadBuffer = mReadBuffer + Me.Read(CHUNK_SIZE, encoding)
		    mBufferedReading = True
		  End If
		  Return DefineEncoding(mReadBuffer, encoding)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function Open(InputStream As FolderItem) As Brotli.BrotliStream
		  ' Create a decompression stream where the compressed input is read from the Source file.
		  
		  Return Open(BinaryStream.Open(InputStream))
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function Open(InputStream As Readable) As Brotli.BrotliStream
		  ' Create a decompression stream where the compressed input is read from the InputStream object.
		  
		  Return New BrotliStream(New Decoder, InputStream)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Read(Count As Integer, encoding As TextEncoding = Nil) As String
		  // Part of the Readable interface.
		  ' This method reads from the compressed stream.
		  ' If BufferedReading is True (the default) then this method will read as many compressed bytes
		  ' as are necessary to produce exactly Count decompressed bytes (or until EOF if there are fewer
		  ' than Count decompressed bytes remaining in the stream).
		  ' If BufferedReading is False then exactly Count compressed bytes are read and fed into the
		  ' decompressor. Any decompressed output is returned: depending on the size of the read request
		  ' and the state of the decompressor this method might return zero bytes. A zero-length return
		  ' value does not indicate an error or the end of the stream; continue to Read from the stream
		  ' until EOF=True.
		  
		  If mDecoder = Nil Then Raise New IOException
		  Dim data As New MemoryBlock(0)
		  Dim ret As New BinaryStream(data)
		  Dim readsz As Integer = Count
		  If BufferedReading Then
		    If Count <= mReadBuffer.LenB Then
		      ' the buffer has enough bytes already
		      ret.Write(LeftB(mReadBuffer, Count))
		      Dim sz As Integer = mReadBuffer.LenB - Count
		      mReadBuffer = RightB(mReadBuffer, sz)
		      ret.Close
		      readsz = 0
		    Else
		      ' not enough bytes in the buffer
		      If mReadBuffer.LenB > 0 Then
		        ret.Write(mReadBuffer)
		        mReadBuffer = ""
		      End If
		      readsz = Max(Count, CHUNK_SIZE) ' read this many more compressed bytes
		    End If
		  End If
		  If readsz > 0 Then
		    If Not mDecoder.Perform(mSource, ret, readsz) Then Raise New BrotliException(mDecoder)
		    ret.Close
		    If BufferedReading Then
		      If data.Size >= Count Then
		        ' buffer any leftovers
		        mReadBuffer = RightB(data, data.Size - Count)
		        data = LeftB(data, Count)
		      ElseIf Not Me.EOF Then
		        ' still need even more bytes!
		        mReadBuffer = data
		        Return Me.Read(Count, encoding)
		      End If
		    End If
		  End If
		  
		  If data <> Nil Then Return DefineEncoding(data, encoding)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ReadError() As Boolean
		  // Part of the Readable interface.
		  If mSource <> Nil Then Return mSource.ReadError Or (mDecoder <> Nil And mDecoder.LastResult = DecodeResult.Error)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Reset()
		  If mEncoder <> Nil Then mEncoder = New Encoder
		  If mDecoder <> Nil Then mDecoder = New Decoder
		  mReadBuffer = ""
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Write(Data As String)
		  // Part of the Writeable interface.
		  ' Write Data to the compressed stream.
		  ' NOTE: the Data may not be immediately written to the output; the compressor will write
		  ' to the output at times dictated by the compression parameters. Use the Flush method to
		  ' forcibly write pending output.
		  
		  If mEncoder = Nil Then Raise New IOException
		  Dim tmp As New BinaryStream(Data)
		  If Not mEncoder.Perform(tmp, mDestination, Operation.Process) Then Raise New BrotliException(mEncoder)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function WriteError() As Boolean
		  // Part of the Writeable interface.
		  If mDestination <> Nil Then Return mDestination.WriteError
		End Function
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mBufferedReading
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If Not value Then mReadBuffer = ""
			  mBufferedReading = value
			End Set
		#tag EndSetter
		BufferedReading As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mDecoder
			End Get
		#tag EndGetter
		Decoder As Brotli.Codec
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mEncoder
			End Get
		#tag EndGetter
		Encoder As Brotli.Codec
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  ' Returns True if the stream is in decompression mode
			  Return mDecoder <> Nil
			End Get
		#tag EndGetter
		IsReadable As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  ' Returns True if the stream is in compression mode
			  Return mEncoder <> Nil
			End Get
		#tag EndGetter
		IsWriteable As Boolean
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mBufferedReading As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mDecoder As Brotli.Decoder
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mDestination As Writeable
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mEncoder As Brotli.Encoder
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mReadBuffer As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mSource As Readable
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mSourceMB As MemoryBlock
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  If mEncoder <> Nil Then Return mEncoder.Quality
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If mEncoder <> Nil Then mEncoder.Quality = value
			End Set
		#tag EndSetter
		Quality As Int32
	#tag EndComputedProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="BufferedReading"
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Encoding"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsReadable"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsWriteable"
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
			Name="Level"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Ratio"
			Group="Behavior"
			Type="Single"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Strategy"
			Group="Behavior"
			Type="Integer"
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
