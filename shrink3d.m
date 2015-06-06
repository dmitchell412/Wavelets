% 3D cropping function for sparse images

function [shrinkx] = shrink3d(x)

shrinkx = x;

for i=1:size(x,1)
    if shrinkx(1,:,:)==0
        shrinkx(1,:,:)=[];
    else
        break;
    end
end

for i=size(x,1):-1:1
    if shrinkx(size(shrinkx,1),:,:)==0
        shrinkx(size(shrinkx,1),:,:)=[];
    else
        break;
    end
end

for j=1:size(x,2)
    if shrinkx(:,1,:)==0
        shrinkx(:,1,:)=[];
    else
        break;
    end
end

for j=size(x,2):-1:1
    if shrinkx(:,size(shrinkx,2),:)==0
        shrinkx(:,size(shrinkx,2),:)=[];
    else
        break;
    end
end

for k=1:size(x,3)
    if shrinkx(:,:,1)==0
        shrinkx(:,:,1)=[];
    else
        break;
    end
end

for k=size(x,3):-1:1
    if shrinkx(:,:,size(shrinkx,3))==0
        shrinkx(:,:,size(shrinkx,3))=[];
    else
        break;
    end
end
