 N = [25,50,75,100];
 Nu = [5,10,15,20];
 lambda = [ 0.2, 1, 5];
 file = fopen('dolatech.txt','w');
 fprintf(file,'\\centering\n');
 for i = N
     for j = Nu
         for k = lambda
             error = doDMC([i,j,k]);
             error = string(error);
             l = string(k);
              fprintf(file,'\\begin{figure}\n');
            fprintf(file,'{\\centering\n');
            fprintf(file,'\\textbf{Error = %s}\\par\\medskip}\n',error);
            fprintf(file,'\\begin{tikzpicture}\n');
            fprintf(file,'\\begin{axis}[\n');
            fprintf(file,'width=0.5\\textwidth,\n');
            fprintf(file,'xmin = 0, xmax = 1200,\n');
            fprintf(file,'xlabel={$k$},\n');
            fprintf(file,'ylabel={$Yzad, \\ Y$},\n');
            fprintf(file,'y tick label style={/pgf/number format/1000 sep=},\n');
            fprintf(file,']\n');
            fprintf(file,'\\addplot[blue, semithick, densely dashed] file {Projekt1/PROJ1_4_YzadDMC.txt};\n');
            fprintf(file,'\\addplot[red,semithick] file {Projekt1/APROJ1_DMC_EXP_N=%d_Nu=%d_lambda=%serror=_%s.txt};\n',i,j,l,error);
            fprintf(file,'\\legend{$Yzad$,$Y$}\n');
            fprintf(file,'\\end{axis}\n');
            fprintf(file,'\\end{tikzpicture}\n');
            fprintf(file,'\\begin{tikzpicture}\n');
            fprintf(file,'\\begin{axis}[\n');
            fprintf(file,'width=0.5\\textwidth,\n');
            fprintf(file,'xmin = 0, xmax = 1200,\n');
            fprintf(file,'xlabel={$k$},\n');
            fprintf(file,'ylabel={$U$},\n');
            fprintf(file,'y tick label style={/pgf/number format/1000 sep=},\n');
            fprintf(file,']\n');
            fprintf(file,'\\addplot[blue,semithick] file {Projekt1/APROJ1_DMC_EXP_STER_N=%d_Nu=%d_lambda=%serror=_%s.txt};\n',i,j,l,error);
            fprintf(file,'\\legend{$U$}\n');
            fprintf(file,'\\end{axis}\n');
            fprintf(file,'\\end{tikzpicture}\n');
            fprintf(file,'\\caption{Przebieg oraz sterowanie dla parametrów N = %d, Nu = %d, $\\lambda$ = %s}\n',i,j,l);
            fprintf(file,'\\label{DMC_EXP_N=%d_Nu=%d_lambda=%s}\n',i,j,l);
            fprintf(file,'\\end{figure}\n');

         end
     end
 end

fclose(file);