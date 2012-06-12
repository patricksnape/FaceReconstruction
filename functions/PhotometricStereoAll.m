%Lights: Nx3 illumination matrix 
%Images: Height x Width x N or Height x Width x 3 x N matrix
function [errorIndex n p q albedo]=PhotometricStereoAll(LightsAll, Images)

%disp('Photometric Stereo All Start...');
LL=(inv(LightsAll'*LightsAll))*LightsAll';
iLL=pinv(LL);

[height width N]=size(Images);
albedo=zeros(height, width);

n=zeros(height, width,3);
p=zeros(height, width);
q=zeros(height, width);
errorIndex=zeros(height, width, N);

Lights=LightsAll;          
  LL=(inv(Lights'*Lights))*Lights';
  iLL=pinv(LL);

for ii=1:height
    for jj=1:width
        %Grey: Different number of lights depending on shadows etc
        I=Images(ii,jj,:);
        I=I(:);
        %remove max and min intensities
        iv=I;
        
        
        iv=iv(:);
        nn=LL*iv;  
        pp=norm(nn);
        albedo(ii,jj)=pp;
        if (pp~=0)
            n(ii,jj,:)=nn./pp;%normal=n/albedo 
            if (n(ii,jj,3)~=0)
                p(ii,jj) = n(ii,jj,1)/n(ii,jj,3);%x/z
                q(ii,jj) = n(ii,jj,2)/n(ii,jj,3);%y/z
            end
        end
    end
end

p(find(p>10))=10;
p(find(p<-10))=-10;
q(find(q>10))=10;
q(find(q<-10))=-10;
%albedo(find(albedo(:)>1))=1;
