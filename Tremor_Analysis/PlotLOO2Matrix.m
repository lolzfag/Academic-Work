function PlotLOO2Matrix
RowTitle = {'ET';'DT';'SCA12';'PD';};
A=LOO2('ET','DT');
B=LOO2('ET','SCA12');
C=LOO2('ET','PD');
D=LOO2('SCA12','DT');
E=LOO2('DT','PD');
F=LOO2('PD','SCA12');

ET = [LOO2('ET','ET');A ;B ;C];
DT = [A;LOO2('DT','DT');D ;E ];
SCA12=[B ;D ;LOO2('SCA12','SCA12'); F ];
PD=[C ;E ;F ;LOO2('PD','PD')];
T = table(ET,DT,SCA12,PD,'RowNames',RowTitle);

uitable('Data',T{:,:},'ColumnName',T.Properties.VariableNames,...
    'RowName',T.Properties.RowNames,'Units', 'Normalized', 'Position',[0, 0, 1, 1]);
% Get the table in string form.
TString = evalc('disp(T)');
% Use TeX Markup for bold formatting and underscores.
TString = strrep(TString,'<strong>','\bf');
TString = strrep(TString,'</strong>','\rm');
TString = strrep(TString,'_','\_');
% Get a fixed-width font.
FixedWidth = get(0,'FixedWidthFontName');
% Output the table using the annotation command.
annotation(gcf,'Textbox','String',TString,'Interpreter','Tex',...
    'FontName',FixedWidth,'Units','Normalized','Position',[0 0 1 1]);
end