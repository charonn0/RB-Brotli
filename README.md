## Introduction
[Brotli](https://github.com/google/brotli) is a generic-purpose lossless compression algorithm with a compression ratio comparable to the best currently available general-purpose compression methods. 

**RB-Brotli** is a Brotli [binding](http://en.wikipedia.org/wiki/Language_binding) for Realbasic and Xojo projects.

## Hilights
* Read and write compressed file or memory streams using a simple [BinaryStream work-alike](https://github.com/charonn0/RB-Brotli/wiki/Brotli.BrotliStream).

## Getting started
The [`BrotliStream`](https://github.com/charonn0/RB-Brotli/wiki/Brotli.BrotliStream) class is a `BinaryStream` work-alike, and implements both the `Readable` and `Writeable` interfaces. Anything [written](https://github.com/charonn0/RB-Brotli/wiki/Brotli.BrotliStream.Write) to a `BrotliStream` is compressed and emitted to the output stream (another `Writeable`); [reading](https://github.com/charonn0/RB-Brotli/wiki/Brotli.BrotliStream.Read) from a `BrotliStream` decompresses data from the input stream (another `Readable`).

Instances of `BrotliStream` can be created from MemoryBlocks, FolderItems, and objects that implement the `Readable` and/or `Writeable` interfaces. For example, creating an in-memory compression stream from a zero-length MemoryBlock and writing a string to it:

```vbnet
  Dim output As New MemoryBlock(0)
  Dim z As New Brotli.BrotliStream(output) ' zero-length creates a compressor
  z.Write("Hello, world!")
  z.Close
```
The string will be processed through the compressor and written to the `output` MemoryBlock. To create a decompressor pass a MemoryBlock whose size is > 0 (continuing from above):

```vbnet
  z = New Brotli.BrotliStream(output) ' output contains the compressed string
  MsgBox(z.Read(64)) ' read the decompressed string
```

## How to incorporate Brotli into your Realbasic/Xojo project
### Import the `Brotli` module
1. Download the RB-Brotli project either in [ZIP archive format](https://github.com/charonn0/RB-Brotli/archive/master.zip) or by cloning the repository with your Git client.
2. Open the RB-Brotli project in REALstudio or Xojo. Open your project in a separate window.
3. Copy the `Brotli` module into your project and save.

### Ensure the Brotli shared libraries are installed
Brotli is not installed by default on most systems; it will need to be installed separately.

RB-Brotli will raise a PlatformNotSupportedException when used if all required DLLs/SOs/DyLibs are not available at runtime. 
