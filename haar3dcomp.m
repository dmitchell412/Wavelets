% 3D Haar wavelet compression

function [WR,nb,pctg] = haar3dcomp(x,nb_or_pctg,thr,n)

if strcmp(nb_or_pctg,'nb')
    nb=thr;
    pctg=nb/length(x(:));
elseif strcmp(nb_or_pctg,'pctg')
    pctg=thr;
    nb=round(pctg*length(x(:)));
end
w='haar';
WT=wavedec3(x,n,w);

cfs=[];
for s=1:length(WT.dec)
    cfs=[cfs; abs(WT.dec{s}(:))];
end
cfs=sort(cfs,'descend');
%nb=round(pctg*length(x(:)));
if nb>length(cfs)
    nb=length(cfs);
end
cutoff=cfs(nb);

for s=1:length(WT.dec)
    WT.dec{s}=WT.dec{s}.*(abs(WT.dec{s})>cutoff);
end

WR=waverec3(WT);