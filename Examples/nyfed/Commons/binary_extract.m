% A simple script to extract posterior simulated distributions from NY-FED model
% Results are saved in structure par
%
% Author: LR. Ver: 09/2017

clear
close all
clc

pwd = 'C:\Users\lucariva\Documents\SourceTree\';
graphs = '2state-toolbox\Figures\NYFed DSGE posteriors\';

test = 0;

switch test
    case 1
        %% EXAMPLE SHOWING HOW BINARY FILES ARE READ AND WRITTEN
        Aw1 = randn(6,2);
        Aw2 = randn(6,2);
        
        fileID = fopen('test.bin','w');
        fwrite(fileID,Aw1,'single');
        fwrite(fileID,Aw2,'single');
        fclose(fileID);
        
        fileID = fopen('test.bin');
        Ar = fread(fileID,[6,4],'single');
        
    case 0
        %% EXTRACT POSTERIORS FOR NYFED MODEL
        
        para_names = { '\alpha';'\zeta_p';'\iota_p';'\delta';'\ups2ilon';'\Phi';'S''''';'h';'a''''';'\nu_l';'\nu_m';'\zeta_w';...
               '\iota_w';'\lambda_w';'r^*';...
               '\psi_1';'\psi_2';'\rho_{r}';'\pi^*';'F(\omega)';'spr_*';'\zeta_{sp}';'\gamma_*';'NEW_5';...
               '\gamma';'W^{adj}';'\chi';'\lambda_f';'g^*';'L^{adj}';...
               '\rho_{z}';'\rho_{\phi}';'\rho_{\chi}';'\rho_{\lambda_f}';'\rho_{\mu}';'\rho_{b}';'\rho_{g}';'\rho_{sigw}';'\rho_{mue}';'\rho_{gamm}';...
               '\sigma_{z}';'\sigma_{\phi}';'\sigma_{\chi}';'\sigma_{\lambda_f}';'\sigma_{\mu}';'\sigma_{b}';'\sigma_{g}';'\sigma_{r}';...
               '\sigma_{sigw}';'\sigma_{mue}';'\sigma_{gamm}'};
           
        nsim = 10000;
        npara = 71;
        nblocks = 11;
        alpha = 0.1;
        nbins = [];
        
        cd([pwd 'DSGE-2014-Sep\save_run\'])
        
        fileID = fopen('params');
        params = fread(fileID,[npara,nsim*nblocks],'single');
        par.modes = mode(round(params,4),2);
        par.means = mean(round(params,4),2);
        temp = grpstats(params',[],'meanci',alpha);
        par.means_ci = [temp(:,:,1)' temp(:,:,2)'];
        clear temp
        OUT = [(1:npara)' par.modes par.means par.means_ci];
        OUT = array2table(OUT,'VariableNames',{'Parameter','Mode','Mean','CI_lb','CI_ub'});
        writetable(OUT,[pwd graphs 'NYFED posteriors.txt']);


        %% Print graphs
        for p = 1:npara
            fh = figure(p);
            [N,edges] = histcounts(params(p,:), 'Normalization', 'probability');
            hold on
            plot(diff(edges)/2+edges(1:end-1),N)
            plot([par.means(p) par.means(p)],[0 1.1*max(N)],'k')
            plot([par.modes(p) par.modes(p)],[0 1.1*max(N)],'r')
            hold off
            descr = {strcat("Mean:    ",string(par.means(p)))...
                strcat("90pc CI: ",string(par.means_ci(p,1))," ",string(par.means_ci(p,2)))...
                strcat("Mode:    ",string(par.modes(p)))};
            text(1.01*min(edges),0.5*max(N),descr);
            if p <= 51; title(['Parameter:' para_names(p)]); end
            set(fh,'color','white');
            print(fh,[pwd graphs num2str(p)],'-dpdf')
            clear fh N edges descr
            close all
        end
        
end