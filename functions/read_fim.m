%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Reads a fim file (with the same format as on Jan. 4, 2005). 
% fim = floating point image
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [m s]= read_fim(fname)

f = fopen(fname, 'r');

if f < 0,
    error('Unable to read file')
end;

s = fread(f, 3, '*uint32');

x = fread(f, double(s(1)*s(2)*s(3)), 'float=>double');
m=[];

index = (1:(s(2)*s(1)));
for i=1:s(3),
    m(:,:,i)=reshape(x(index * s(3) - (s(3)-i)),s(1),s(2))';
end;
fclose(f);
