# Build instruction
The project is located in /workspace.
```bash
cd /workspace
defects4j compile
```

# Test instruction
```bash
cd /workspace
defects4j test
```

# Issue description
The UTF8StreamJson Parser constructor allows to specify the start position. But it doesn't set the "_currInputRowStart" as the same value. It is still 0. So when raise the exception, the column calculation (ParserBase.getCurrentLocation() )will be wrong.

int col = _inputPtr - _currInputRowStart + 1; // 1-based

public UTF8StreamJsonParser(IOContext ctxt, int features, InputStream in,
ObjectCodec codec, BytesToNameCanonicalizer sym,
byte[] inputBuffer, int start, int end,
boolean bufferRecyclable)
