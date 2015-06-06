% 2D Compression in Haar, Daubechies, symlet, coifflet, biorthogonal
% spline, and curvelet bases

close all;
clear all;

x=load_nii('ICBM_grey_white_csf.nii');
x=x.img(:,:,81);
%load woman;
%x=X;

n=8;
thr=0:0.05:1;
w={'haar','db8','sym8','coif5','bior5.5'};
sorh={'h','s'};
opt='gbl';
keepapp=1;
perfw=zeros(5,length(thr));

pctg=0.005:0.005:0.5;
perfc=zeros(3,length(pctg));

%figsize=[100,100,1000,800];
fsize=16;
lsize=3;
%f1=figure('Position',figsize);
%f2=figure('Position',figsize);
f1=figure;
f2=figure;

for k=1:length(sorh)

    for j=1:length(w)
        [c,l]=wavedec2(x,n,w{j});

        for i=1:length(thr)

            [xd,cxd,lxd,perf0,perfl2]=wdencmp(opt,c,l,w{j},n,thr(i),sorh{k},keepapp);

            cxd=sparse(cxd);
            cxd_density=100*nnz(cxd)/numel(cxd);
            perfl2log=log10(norm(x-xd)/norm(x));

            perfw(:,i)=[perf0,perfl2log,cxd_density,nnz(cxd)/length(x(:)),thr(i)];

        end

        if (k==1)
            figure(f1);
        elseif (k==2)
            figure(f2);
        end
        hold all;
        %plot(perfw(4,:),perfw(2,:),'LineWidth',lsize);
        plot(perfw(5,:),perfw(2,:),'LineWidth',lsize);
        
    end

end

for i=1:length(pctg)

    %tic;
    C = fdct_wrapping(x,0);
    %toc;

    cfs =[];
    for s=1:length(C)
        for w=1:length(C{s})
            cfs = [cfs; abs(C{s}{w}(:))];
        end
    end
    cfs = sort(cfs); cfs = cfs(end:-1:1);
    nb = round(pctg(i)*length(cfs));
    cutoff = cfs(nb);

    for s=1:length(C)
        for w=1:length(C{s})
            C{s}{w} = C{s}{w} .* (abs(C{s}{w})>cutoff);
        end
    end

    %tic;
    y = ifdct_wrapping(C,0);
    %toc;

    perfc(:,i)=[pctg(i),log10(norm(x-y)/norm(x)),nb/length(x(:))];

end

figure(f1);
hold all;
plot(perfc(3,:),perfc(2,:),'LineWidth',lsize);
%title('hard thresh');
f1legend=legend('Haar','Daubechies','Symlet','Coiflet','Biorthogonal','Curvelet','Location','southeast');
f1xlabel=xlabel('Fraction of Non-Zero Coefficients Relative to Number of Pixels','FontSize',fsize);
f1ylabel=ylabel('Log of Normalized l2 Distance','FontSize',fsize);
%set(f1legend,'FontSize',18);
%set(f1xlabel,'FontSize',18);
%set(f1ylabel,'FontSize',18);
set(gca,'FontSize',fsize);

figure(f2);
hold all;
plot(perfc(3,:),perfc(2,:),'LineWidth',lsize);
%title('soft thresh');
f2legend=legend('Haar','Daubechies','Symlet','Coiflet','Biorthogonal','Curvelet','Location','southeast');
f2xlabel=xlabel('Fraction of Non-Zero Coefficients Relative to Number of Pixels','FontSize',fsize);
f2ylabel=ylabel('Log of Normalized L2 Distance','FontSize',fsize);
%set(f2legend,'FontSize',18);
%set(f2xlabel,'FontSize',18);
%set(f2ylabel,'FontSize',18);
set(gca,'FontSize',fsize);
saveas(f1,'f1.jpg');
saveas(f2,'f2.jpg');