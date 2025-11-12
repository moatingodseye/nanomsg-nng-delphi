unit nngConstant;

interface

const
  nngPeriod = 100; // ms between idle checks
  nngGranularity = 10; // ms waiting between actions Thread.WaitFor(nngGranularity)
  nngBuffer = 512; // buffer size used for transport/packet
  
implementation

end.
