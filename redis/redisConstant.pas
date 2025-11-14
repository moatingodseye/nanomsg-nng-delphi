unit redisConstant;

interface

const
  keyCommand = 'CMD';
  keyKey = 'KEY';
  keyValue = 'VAL';
  cmdAdd = 1;
  cmdExist = 2;
  cmdRemove = 3;

const
  keyResponse = 'RES';
  repACK = 1;
  repNACK = 2;

const
  cCommand : Array[1..3] of String = ('Add','Exist','Remove');
  cResponse : Array[0..1] of String = ('ACK','NACK');

implementation

end.
