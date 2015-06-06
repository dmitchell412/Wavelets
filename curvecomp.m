clear all;
close all;

%disp(' ');
%disp('fdct_wrapping_demo_recon.m -- Partial Curvelet reconstruction.');
%disp(' ');
%disp('We apply the curvelet transform to an image, select a percentage');
%disp('of the largest coefficients (in modulus), and set the others');
%disp('to zero. We then take the inverse curvelet transform to obtain');
%disp('a partial reconstruction of the original image.');
%disp(' ');

% fdct_wrapping_demo_recon.m -- Partial curvelet reconstruction.

% Set the percentage of coefficients used in the partial reconstruction 
%pctg = 0.001:0.001:0.1;

% Load image
%X = imread('Lena.jpg'); %load Lena; X = Lena; clear Lena;
X = load_nii('ICBM_grey_white_csf.nii');
X = X.img(:,:,81);

figsize=[100,100,500,500];
f1=figure('Position',figsize);
f2=figure('Position',figsize);
genvarname('f',num2str(i));

for i=1:100
pctg=.001*i;
% Forward curvelet transform
disp('Take curvelet transform: fdct_wrapping');
%tic; C = fdct_wrapping(double(X),0); toc;
tic; C = fdct_wrapping(X); toc;

% Get threshold value
cfs =[];
for s=1:length(C)
  for w=1:length(C{s})
    cfs = [cfs; abs(C{s}{w}(:))];
  end
end
cfs = sort(cfs); cfs = cfs(end:-1:1);
nb = round(pctg*length(cfs));
cutoff = cfs(nb);

% Set small coefficients to zero
for s=1:length(C)
  for w=1:length(C{s})
    C{s}{w} = C{s}{w} .* (abs(C{s}{w})>cutoff);
  end
end

disp('Take inverse curvelet transform: ifdct_wrapping');
tic; Y = ifdct_wrapping(C,0); toc;

perf(i,:)=[pctg,log10(norm(X-Y)/norm(X)),nb];


if (mod(i,10)==0)
eval(['f' num2str(i/10+2) '=figure']);
subplot(2,2,1); colormap gray; imagesc(real(X)); axis('image'); title('original image');
subplot(2,2,2); colormap gray; imagesc(real(Y)); axis('image'); title(['partial reconstruction, pctg=',num2str(pctg)]);
end

end

for i=10:10:100
eval(['figure(f' num2str(i/10+2) ')']);
subplot(2,2,3); hold all; plot(perf(:,3),perf(:,2)); axis([0,12000,0,40]); xlabel('nnz coefficients'); ylabel('l2 norm'); title('Threshold');
hx=graph2d.constantline(perf(i,3)); changedependvar(hx,'x'); plot(hx);
end

figure(f1);
plot(perf(:,1),perf(:,2));
title('Curvelets');
xlabel('% nonzero coefficients');
ylabel('l2 norm');

figure(f2);
plot(perf(:,3),perf(:,2));
title('Curvelets');
xlabel('nnz coefficients');
ylabel('l2 norm');

saveas(f1,'f1.jpg');
saveas(f2,'f2.jpg');
saveas(f3,'f3.jpg');
saveas(f4,'f4.jpg');
saveas(f5,'f5.jpg');
saveas(f6,'f6.jpg');
saveas(f7,'f7.jpg');
saveas(f8,'f8.jpg');
saveas(f9,'f9.jpg');
saveas(f10,'f10.jpg');
saveas(f11,'f11.jpg');
saveas(f12,'f12.jpg');

%for i=1:12
%saveas(['f',num2str(i)],['f',num2str(i),'.jpg']);
%end