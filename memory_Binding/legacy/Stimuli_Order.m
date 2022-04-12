function [stim] = Stimuli_Order_WM(stim,dirs)

Orden_EPrime = 1:18;
Orden_Matlab = [2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19];


%%%%%%%%%% INICIO ESTIMULOS PERCEPCION %%%%%%%%%%

%%% Creo matriz con estimulos en cada posicion y transpongo (copiado de
%%% E-Prime) 

if isequal(design.AmountOfStimuli, '2')
  stim.Perception_Stimuli = {000 000 000 58 000 000 36 000 000 000 000 000 36 000 000 000 58 000
                        000 12 000 000 000 000 000 65 000 000 62 000 000 000 15 000 000 000
                        000 000 000 000 78 000 12 000 000 000 000 000 18 000 000 000 000 72
                        000 000 21 000 000 000 000 000 18 000 21 000 000 000 18 000 000 000
                        000 000 53 31 000 000 000 000 000 31 000 000 000 000 53 000 000 000
                        000 000 000 000 000 51 84 000 000 000 000 000 81 000 000 000 000 54
                        000 000 81 000 000 000 45 000 000 000 000 85 000 000 41 000 000 000
                        000 46 000 000 000 000 000 000 28 000 000 000 000 48 000 000 000 26
                        000 17 000 31 000 000 000 000 000 000 000 000 31 000 17 000 000 000
                        000 000 000 77 000 000 000 000 88 000 000 000 88 000 77 000 000 000}';
elseif isequal(design.AmountOfStimuli, '3')
  stim.Perception_Stimuli = {000	77	000	22	000	000	000	000	55	000	55	000	000	000	22	77	000	000
                        000	000	000	000	42	000	31	28	000	42	000	000	28	000	000	31	000	000
                        000	000	31	000	17	000	000	28	000	000	28	000	000	000	000	17	000	31
                        000	000	000	000	13	75	000	000	26	000	26	000	000	000	000	15	000	73
                        81	000	000	000	000	45	34	000	000	45	000	84	31	000	000	000	000	000
                        000	000	51	48	000	000	000	000	73	71	000	53	000	000	000	48	000	000
                        000	000	000	54	000	000	32	65	000	32	000	000	000	000	000	65	000	54
                        000	000	000	43	25	000	000	34	000	000	000	23	000	000	000	000	45	34
                        000	000	000	73	000	000	45	18	000	48	000	000	000	15	000	000	73	000
                        000	000	000	61	47	14	000	000	000	000	47	000	14	000	000	000	61	000}';
else
  stim.Perception_Stimuli = {000	77	000	22	000	000	000	000	55	000	55	000	000	000	22	77	000	000
                        000	000	000	000	42	000	31	28	000	42	000	000	28	000	000	31	000	000
                        000	000	31	000	17	000	000	28	000	000	28	000	000	000	000	17	000	31
                        000	000	000	000	13	75	000	000	26	000	26	000	000	000	000	15	000	73
                        81	000	000	000	000	45	34	000	000	45	000	84	31	000	000	000	000	000
                        000	000	51	48	000	000	000	000	73	71	000	53	000	000	000	48	000	000
                        000	000	000	54	000	000	32	65	000	32	000	000	000	000	000	65	000	54
                        000	000	000	43	25	000	000	34	000	000	000	23	000	000	000	000	45	34
                        000	000	000	73	000	000	45	18	000	48	000	000	000	15	000	000	73	000
                        000	000	000	61	47	14	000	000	000	000	47	000	14	000	000	000	61	000}';
end

%%% Reorganizo las posiciones de los estimulos por como estan definidas en
%%% E-Prime
stim.Stimuli_Perception_Database_Dummy = stim.Stimuli_Perception_Database;
for rearange = 2:size(stim.Stimuli_Perception_Database,1)
        stim.Stimuli_Perception_Database_Dummy(rearange,1:2) = stim.Stimuli_Perception_Database(Orden_Matlab(rearange-1), 1:2);
end
stim.Stimuli_Perception_Database = stim.Stimuli_Perception_Database_Dummy;

%%% Borro lo que no es estimulo del directorio Solo una vez se hace esto y
%%% se utiliza el mismo directorio para ShapeColor
Counter = 1;
for SpecificStimuli = 1:size(dirs.PerceptionStimuliDir,1)
    if regexp(dirs.PerceptionStimuliDir(SpecificStimuli,1).name, 'TrialPerc', 'ONCE')
        stim.Perception_Trial_Explanation = dirs.PerceptionStimuliDir(SpecificStimuli,1).name;
    elseif regexp(dirs.PerceptionStimuliDir(SpecificStimuli,1).name, 'TrialTask', 'ONCE')
        stim.ShapeColor_Trial_Explanation = dirs.PerceptionStimuliDir(SpecificStimuli,1).name;
    elseif regexp(dirs.PerceptionStimuliDir(SpecificStimuli,1).name, 'FixCross', 'ONCE')
        stim.FixationCross = dirs.PerceptionStimuliDir(SpecificStimuli,1).name;
    end
    if isempty(regexp(dirs.PerceptionStimuliDir(SpecificStimuli,1).name, 'img', 'ONCE'))
        Dir_Del_List(Counter,1) = SpecificStimuli; %#ok<*SAGROW>
        Counter = Counter + 1;
    end
end
for Delete_Non_Images = 1:length(Dir_Del_List)
    Images = 1:length(Dir_Del_List);
    stim.PerceptionStimuliDir(Dir_Del_List(Delete_Non_Images),:) = [];
    Dir_Del_List = Dir_Del_List - 1;
end
clear Dir_Del_List SpecificStimuli Delete_Non_Images

% Modifico Nombres de la matriz para que en vez de numeros tengan los
% nombres de las imagenes y ya callearlas de esta database directamente
dirs.DummyStimuliDir = {dirs.PerceptionStimuliDir(:,1).name}';
stim.Perception_Stimuli_Dummy = stim.Perception_Stimuli;
for ReplaceStimuli = 1:size(dirs.DummyStimuliDir,1)
    % Defino en cada imagen en que indices se encuentran los numeros en el
    % nombre
    %% Contadores para poner a punto los nombres de los estimulos
    Counter = 1;
    Deletion = 1;
    Num = regexp(dirs.PerceptionStimuliDir(ReplaceStimuli,1).name,'\d');
    Length_Num = length(Num);
    % Itero por cada letra
    for Del_Letters = 1:size(dirs.DummyStimuliDir{ReplaceStimuli,1},2)
        % Como es secuencial no hay problema en saltearse numeros
        if  Counter ~= Length_Num + 1  && Del_Letters == Num(Counter)
            Counter = Counter + 1;
            Deletion = Deletion + 1;
        else
            dirs.DummyStimuliDir{ReplaceStimuli,1}(Deletion) = [];
        end
    end
    % Reemplazo los numeros con el nombre de las imagenes (Hagase notar que
    % deben tener numeros incluidos en el nombre para que funcione.
    ReplaceList = find([stim.Perception_Stimuli_Dummy{:}] == str2double(dirs.DummyStimuliDir{ReplaceStimuli,1}));
    for ReplaceIter = 1:length(ReplaceList)
        stim.Perception_Stimuli{ReplaceList(ReplaceIter)} = dirs.PerceptionStimuliDir(ReplaceStimuli,1).name;
    end
end
clear Counter Deletion Num Length_Num Deletion ReplaceList DummyStimuliDir


%%%%%%%%%% FIN ESTIMULOS PERCEPCION %%%%%%%%%%
%???????????????????????????%
%              ? ~~~          ? ~~~         %
%      ?    ? ~~~          ? ~ ? ~~~  ?   %
%              ? ~~~    ? ~~ ? ~~~   ? ~~~ %
%                          ? ~ ~ ? ~~~      %
%   ? ___     ?___           ? ~~~   ?__  %
%%%%%%%%%% INICIO ESTIMULOS SHAPEONL_Y %%%%%%%%

%%% Creo matriz con estimulos en cada posicion y transpongo (copiado de
%%% E-Prime) 

if isequal(design.AmountOfStimuli, '2')
    stim.Task_ShapeOnly_Stimuli = {000 000 000 000 000 000 000 41 51 000 000 000 11 000 000 21 000 000
                    000 000 61 000 51 000 000 000 000 000 000 000 11 000 000 000 000 21
                    000 51 000 000 000 000 000 61 000 000 000 000 71 000 000 81 000 000
                    000 000 11 000 000 000 000 21 000 31 000 000 000 000 000 41 000 000
                    000 000 81 000 11 000 000 000 000 000 000 31 41 000 000 000 000 000
                    000 41 000 000 000 000 000 000 51 000 000 71 81 000 000 000 000 000
                    000 31 000 000 000 000 000 000 41 000 000 000 51 000 000 000 000 61
                    81 000 000 71 000 000 000 000 000 000 000 000 000 000 51 61 000 000
                    000 000 000 000 11 000 81 000 000 000 000 000 000 11 000 000 51 000
                    000 000 000 61 000 000 71 000 000 000 000 000 000 000 000 31 000 41
                    71 000 61 000 000 000 000 000 000 000 31 41 000 000 000 000 000 000
                    31 000 000 000 000 000 000 000 41 51 000 000 000 000 61 000 000 000
                    000 000 61 51 000 000 000 000 000 71 000 81 000 000 000 000 000 000
                    000 000 000 000 71 000 61 000 000 000 11 000 21 000 000 000 000 000
                    000 000 000 000 41 000 51 000 000 000 11 000 000 000 000 21 000 000
                    000 000 000 61 000 000 000 71 000 000 000 000 31 000 000 000 000 41
                    000 000 000 000 51 000 41 000 000 000 000 41 51 000 000 000 000 000
                    11 000 81 000 000 000 000 000 000 000 000 000 000 81 000 000 000 11
                    000 000 000 000 000 81 000 71 000 000 71 000 000 000 000 000 81 000
                    000 000 000 21 31 000 000 000 000 000 000 000 000 000 21 000 000 31
                    000 000 31 000 000 41 000 000 000 41 000 000 31 000 000 000 000 000
                    81 000 71 000 000 000 000 000 000 000 000 81 000 71 000 000 000 000
                    21 000 11 000 000 000 000 000 000 21 11 000 000 000 000 000 000 000
                    000 000 71 000 000 000 000 000 81 81 000 71 000 000 000 000 000 000
                    000 000 51 61 000 000 000 000 000 000 51 000 000 000 000 000 61 000
                    000 000 000 31 000 000 000 000 21 000 000 000 000 000 000 31 000 21
                    81 000 000 000 000 000 11 000 000 000 11 000 000 000 000 000 81 000
                    000 000 000 000 21 31 000 000 000 31 000 000 000 21 000 000 000 000
                    000 000 21 000 000 000 11 000 000 000 000 21 000 000 000 11 000 000
                    000 000 21 000 000 11 000 000 000 000 000 000 000 000 000 11 21 000
                    000 000 21 000 000 000 31 000 000 000 000 31 000 000 000 000 000 21
                    000 000 000 000 000 41 000 000 31 41 000 000 000 000 31 000 000 000
                    }';
elseif isequal(design.AmountOfStimuli, '3')
    stim.Task_ShapeOnly_Stimuli = {21	000	000	000	000	000	11	31	000	000	21	000	81	000	000	41	000	000
                    000	000	000	000	000	000	31	51	41	81	000	41	000	11	000	000	000	000
                    000	31	41	000	000	000	000	21	000	000	000	000	000	000	81	71	000	31
                    41	000	000	000	000	61	000	51	000	41	000	000	000	000	000	71	31	000
                    000	000	000	41	000	51	61	000	000	81	000	000	000	000	21	41	000	000
                    000	000	000	71	000	000	11	81	000	000	000	000	000	71	41	21	000	000
                    11	000	71	000	000	000	000	81	000	71	000	000	000	000	000	000	61	31
                    000	000	000	11	21	000	000	81	000	000	11	61	000	000	31	000	000	000
                    000	61	000	000	000	71	000	000	81	000	51	31	81	000	000	000	000	000
                    51	000	000	000	61	000	000	000	41	000	000	000	71	000	000	31	000	61
                    000	000	81	000	000	11	000	000	21	000	000	31	81	71	000	000	000	000
                    21	000	000	31	000	000	000	000	41	000	000	000	71	61	000	000	000	41
                    000	11	000	71	000	000	000	000	81	11	000	31	000	000	000	000	61	000
                    000	000	000	71	000	61	000	51	000	61	000	000	000	000	11	81	000	000
                    000	000	11	000	000	000	31	21	000	51	000	61	000	000	000	000	21	000
                    000	000	000	11	21	31	000	000	000	000	11	000	000	71	000	000	51	000
                    11	000	000	21	000	31	000	000	000	11	000	000	21	000	000	31	000	000
                    000	000	41	000	31	000	51	000	000	000	000	000	000	51	000	000	31	41
                    000	000	000	000	71	000	81	61	000	61	000	71	000	000	000	81	000	000
                    41	000	000	51	61	000	000	000	000	000	51	000	000	000	61	000	000	41
                    000	61	000	71	51	000	000	000	000	000	000	71	000	51	000	000	000	61
                    000	000	000	000	000	000	61	71	51	61	000	51	000	000	71	000	000	000
                    11	21	000	81	000	000	000	000	000	21	000	000	000	000	81	11	000	000
                    21	000	000	11	000	000	31	000	000	11	000	000	31	000	000	000	000	21
                    000	51	000	000	000	61	000	000	71	000	71	000	61	000	000	51	000	000
                    61	000	000	81	71	000	000	000	000	81	000	000	61	000	000	71	000	000
                    41	31	000	000	000	51	000	000	000	000	000	31	51	000	000	000	000	41
                    000	000	81	000	000	000	11	21	000	000	000	000	000	000	000	21	11	81
                    000	000	000	000	71	81	000	000	61	000	61	71	000	000	000	000	81	000
                    51	000	71	000	000	000	000	61	000	000	71	000	000	000	61	000	51	000
                    000	000	000	000	41	61	51	000	000	51	41	000	61	000	000	000	000	000
                    81	000	000	000	11	71	000	000	000	000	000	000	000	81	71	000	000	11
                    }';
else
    stim.Task_ShapeOnly_Stimuli = {81	31	21	000	000	000	11	000	000	81	000	71	61	000	31	000	000	000
                    000	21	000	11	000	31	000	41	000	000	21	31	000	000	000	71	81	000
                    61	000	51	31	000	41	000	000	000	11	31	000	000	21	51	000	000	000
                    000	000	000	61	000	000	11	71	81	000	000	000	000	41	61	71	000	51
                    000	11	000	21	000	000	000	71	81	000	000	11	000	000	31	21	41	000
                    000	31	21	000	41	000	51	000	000	000	31	000	000	000	71	81	000	51
                    71	000	000	000	51	61	000	81	000	11	000	000	21	000	000	61	000	81
                    000	000	11	81	000	21	000	000	31	31	000	51	61	000	000	81	000	000
                    000	000	000	61	41	51	000	71	000	000	61	000	11	71	000	000	000	21
                    000	000	11	71	000	000	81	000	61	000	000	21	000	81	000	000	61	31
                    21	000	000	71	000	000	81	000	11	71	81	31	000	41	000	000	000	000
                    000	71	000	51	000	81	000	61	000	000	21	000	000	31	000	000	61	81
                    000	000	11	000	21	000	31	000	41	11	000	31	000	000	000	000	71	81
                    000	000	51	61	31	000	000	000	41	31	21	000	61	000	000	000	41	000
                    000	81	000	71	000	61	000	51	000	11	61	000	81	000	21	000	000	000
                    000	81	000	000	11	21	71	000	000	000	000	71	000	31	81	51	000	000
                    21	000	000	000	000	000	31	41	51	000	51	21	000	000	31	000	41	000
                    000	11	21	000	000	000	000	71	81	000	000	21	11	71	81	000	000	000
                    000	000	81	000	000	11	71	61	000	000	000	000	81	61	000	71	000	11
                    21	000	000	000	000	51	31	41	000	000	51	000	000	31	000	21	000	41
                    000	000	51	71	000	000	000	61	41	000	000	000	41	51	71	000	61	000
                    000	000	000	000	000	81	31	11	21	000	000	31	11	81	000	000	000	21
                    000	61	000	71	000	000	41	000	51	41	000	71	000	000	61	000	000	51
                    31	000	000	51	41	000	000	21	000	000	000	000	31	21	000	41	000	51
                    000	000	61	000	51	000	31	000	41	000	000	000	000	51	31	41	61	000
                    21	000	000	000	000	11	41	31	000	000	31	000	000	41	21	11	000	000
                    61	000	000	000	51	000	41	71	000	000	000	51	41	61	000	000	000	71
                    61	71	000	81	000	000	000	000	11	000	11	000	71	000	61	000	000	81
                    81	31	21	000	000	000	11	000	000	000	000	81	31	000	11	000	000	21
                    41	61	000	000	000	31	000	51	000	000	000	000	000	61	41	000	51	31
                    000	71	000	000	81	51	61	000	000	71	81	51	000	000	61	000	000	000
                    21	000	000	000	11	31	000	41	000	000	31	41	000	000	21	000	11	000}';
end

%%% Borro lo que no es estimulo del directorio para ShapeOnly %%%
Counter = 1;
for SpecificStimuli = 1:size(dirs.TaskShapeOnlyStimuliDir,1)
    if regexp(dirs.TaskShapeOnlyStimuliDir(SpecificStimuli,1).name, 'TrialTask', 'ONCE')
        dirs.Task_Trial_Explanation = dirs.TaskShapeOnlyStimuliDir(SpecificStimuli,1).name;
    end
    if isempty(regexp(dirs.TaskShapeOnlyStimuliDir(SpecificStimuli,1).name, 'img', 'ONCE'))
        Dir_Del_List(Counter,1) = SpecificStimuli;
        Counter = Counter + 1;
    end
end
for Delete_Non_Images = 1:length(Dir_Del_List)
    dirs.TaskShapeOnlyStimuliDir(Dir_Del_List(Delete_Non_Images),:) = [];
    Dir_Del_List = Dir_Del_List - 1;
end
clear Dir_Del_List SpecificStimuli Delete_Non_Images

% Modifico Nombres de la matriz para que en vez de numeros tengan los
% nombres de las imagenes y ya callearlas de esta database directamente
DummyStimuliDir = {dirs.TaskShapeOnlyStimuliDir(:,1).name}';
stim.Task_ShapeOnly_Stimuli_Dummy = stim.Task_ShapeOnly_Stimuli;
for ReplaceStimuli = 1:size(DummyStimuliDir,1)
    % Defino en cada imagen en que indices se encuentran los numeros en el
    % nombre
    %% Contadores para poner a punto los nombres de los estimulos
    Counter = 1;
    Deletion = 1;
    Num = regexp(dirs.TaskShapeOnlyStimuliDir(ReplaceStimuli,1).name,'\d');
    Length_Num = length(Num);
    % Itero por cada letra
    for Del_Letters = 1:size(DummyStimuliDir{ReplaceStimuli,1},2)
        % Como es secuencial no hay problema en saltearse numeros
        if  Counter ~= Length_Num + 1  && Del_Letters == Num(Counter)
            Counter = Counter + 1;
            Deletion = Deletion + 1;
        else
            DummyStimuliDir{ReplaceStimuli,1}(Deletion) = [];
        end
    end
    % Reemplazo los numeros con el nombre de las imagenes (Hagase notar que
    % deben tener numeros incluidos en el nombre para que funcione.
    ReplaceList = find([stim.Task_ShapeOnly_Stimuli_Dummy{:}] == str2double(DummyStimuliDir{ReplaceStimuli,1}));
    for ReplaceIter = 1:length(ReplaceList)
        stim.Task_ShapeOnly_Stimuli{ReplaceList(ReplaceIter)} = dirs.TaskShapeOnlyStimuliDir(ReplaceStimuli,1).name;
    end
end
clear Counter Deletion Num Length_Num Deletion ReplaceList DummyStimuliDir

%%%%%%%%%% FIN ESTIMULOS SHAPEONLY %%%%%%%%



%%%%%%%%%% INICIO ESTIMULOS SHAPECOLOR %%%%%%%

%%% Creo matriz con estimulos en cada posicion y transpongo (copiado de
%%% E-Prime) 
stim.Task_ShapeColor_Stimuli = {};
if isequal(design.AmountOfStimuli, '2')
 stim.Task_ShapeColor_Stimuli = {000	000	000	000	000	72	83	000	000	000	73	82	000	000	000	000	000	000
                            000	12	000	000	000	81	000	000	000	000	000	000	000	11	000	82	000	000
                            000	000	000	54	65	000	000	000	000	000	64	000	000	000	000	000	55	000
                            000	000	000	54	000	000	000	65	000	000	64	000	000	000	000	000	000	55
                            000	000	000	000	47	000	000	000	36	46	000	000	000	000	000	000	37	000
                            000	000	000	000	27	000	000	38	000	000	000	000	000	000	000	000	37	28
                            000	000	000	000	000	000	000	63	74	73	64	000	000	000	000	000	000	000
                            56	000	000	000	000	000	000	000	45	000	000	000	55	000	000	000	46	000
                            000	000	000	000	83	000	000	000	72	000	82	000	000	000	000	000	73	000
                            81	000	000	12	000	000	000	000	000	000	000	000	000	000	000	82	11	000
                            000	000	000	000	21	18	000	000	000	000	000	000	000	28	000	11	000	000
                            000	000	65	000	000	000	000	000	54	000	000	000	000	000	55	000	64	000
                            12	000	000	000	000	81	000	000	000	000	000	000	000	000	000	11	82	000
                            000	27	38	000	000	000	000	000	000	000	000	28	000	37	000	000	000	000
                            000	21	18	000	000	000	000	000	000	11	000	000	000	28	000	000	000	000
                            000	27	000	000	000	38	000	000	000	37	000	000	28	000	000	000	000	000
                            000	63	000	000	000	74	000	000	000	74	000	63	000	000	000	000	000	000
                            000	000	000	000	12	000	000	000	81	000	81	000	000	000	000	000	12	000
                            83	72	000	000	000	000	000	000	000	000	83	000	000	72	000	000	000	000
                            000	000	72	000	000	83	000	000	000	000	000	000	83	000	000	000	72	000
                            000	000	000	72	000	000	000	83	000	000	000	83	000	72	000	000	000	000
                            000	000	000	000	36	000	000	47	000	000	000	36	000	47	000	000	000	000
                            000	000	000	45	000	000	56	000	000	000	000	000	56	000	000	000	000	45
                            000	000	000	000	56	45	000	000	000	000	56	000	45	000	000	000	000	000
                            54	65	000	000	000	000	000	000	000	000	000	54	000	000	000	65	000	000
                            000	000	000	000	18	000	000	000	21	000	000	18	000	21	000	000	000	000
                            000	000	74	000	63	000	000	000	000	000	000	74	000	000	000	63	000	000
                            000	000	000	000	000	000	63	74	000	000	000	000	000	000	74	63	000	000
                            000	000	000	000	000	47	000	000	36	000	000	000	000	47	000	36	000	000
                            000	000	000	000	000	36	47	000	000	47	000	000	36	000	000	000	000	000
                            000	000	56	000	000	45	000	000	000	000	56	000	000	000	000	45	000	000
                            27	000	000	000	000	000	000	38	000	000	000	000	000	27	000	000	000	38}';
elseif isequal(design.AmountOfStimuli, '3')
 stim.Task_ShapeColor_Stimuli = {61	000	000	62	000	000	000	63	000	000	000	64	62	65	000	000	000	000
                            000	000	46	000	48	000	47	000	000	000	000	42	000	000	43	000	000	46
                            63	000	000	65	64	000	000	000	000	61	62	000	000	000	000	65	000	000
                            000	000	000	73	000	75	000	74	000	000	000	77	000	000	78	75	000	000
                            000	33	000	000	000	000	000	31	32	000	000	37	000	38	32	000	000	000
                            000	82	81	000	000	000	000	88	000	000	83	000	000	000	87	000	88	000
                            000	75	000	000	73	000	000	000	74	76	000	75	000	77	000	000	000	000
                            61	000	000	000	68	000	000	000	67	000	000	63	64	67	000	000	000	000
                            000	000	38	31	37	000	000	000	000	000	000	000	000	000	35	36	000	38
                            000	51	52	58	000	000	000	000	000	000	000	000	53	000	000	54	51	000
                            000	000	28	000	000	21	22	000	000	000	26	000	000	000	27	000	000	28
                            000	000	000	16	15	14	000	000	000	000	000	000	11	000	12	000	000	15
                            000	000	18	17	000	000	16	000	000	000	12	000	000	000	000	13	000	16
                            000	000	000	82	84	000	000	000	83	000	000	000	000	000	85	000	86	84
                            25	27	26	000	000	000	000	000	000	21	000	000	000	000	000	000	27	22
                            000	000	000	000	43	41	000	000	42	000	43	45	000	000	000	000	000	46
                            22	24	23	000	000	000	000	000	000	000	24	000	000	000	23	000	22	000
                            57	55	000	000	000	000	000	000	56	000	56	55	57	000	000	000	000	000
                            13	000	000	12	000	14	000	000	000	000	000	000	000	000	000	12	14	13
                            000	000	47	48	000	41	000	000	000	41	000	000	47	000	000	000	000	48
                            000	000	25	000	000	000	24	000	26	000	25	24	000	26	000	000	000	000
                            000	000	000	000	78	000	76	77	000	76	000	000	000	000	78	000	77	000
                            000	000	000	000	000	35	000	34	33	000	000	000	000	34	35	000	33	000
                            14	000	16	000	000	000	15	000	000	14	16	000	15	000	000	000	000	000
                            000	82	000	81	000	000	000	83	000	000	000	000	000	81	000	83	82	000
                            000	64	000	000	62	000	63	000	000	63	000	000	000	62	000	000	000	64
                            000	36	35	34	000	000	000	000	000	000	000	000	34	35	000	36	000	000
                            58	51	000	000	000	000	000	57	000	58	57	000	000	000	51	000	000	000
                            000	51	000	000	000	000	58	000	52	000	000	000	000	000	58	000	51	52
                            76	78	000	000	77	000	000	000	000	000	000	77	000	000	76	78	000	000
                            000	45	46	47	000	000	000	000	000	000	000	000	000	000	46	45	47	000
                            86	85	000	87	000	000	000	000	000	000	000	000	000	87	000	000	85	86}';
else
 stim.Task_ShapeColor_Stimuli = {83	61	000	72	000	14	000	000	000	61	000	83	12	000	74	000	000	000
                            85	000	000	000	000	74	000	63	52	000	000	000	84	52	63	75	000	000
                            000	63	000	000	52	000	74	000	85	72	63	000	000	54	000	85	000	000
                            000	000	27	41	000	000	38	16	000	41	000	000	18	36	000	000	000	27
                            000	000	16	38	000	41	000	000	27	000	000	17	000	000	38	26	000	41
                            000	000	000	000	63	85	74	52	000	000	000	64	73	000	000	52	000	85
                            38	16	000	41	000	000	27	000	000	000	000	000	36	000	18	27	000	41
                            61	000	000	72	000	14	000	000	83	81	000	000	72	000	14	63	000	000
                            78	12	000	000	000	23	000	000	81	23	000	000	82	000	000	11	000	78
                            000	58	000	000	000	25	000	47	36	000	37	58	46	25	000	000	000	000
                            32	21	87	000	000	000	000	18	000	000	000	11	28	87	000	000	000	32
                            56	000	67	000	45	000	000	34	000	47	000	000	000	34	56	65	000	000
                            000	000	000	61	72	000	14	000	83	000	000	000	62	14	71	83	000	000
                            000	000	000	43	54	76	65	000	000	46	54	73	000	000	000	000	65	000
                            000	000	18	21	000	87	32	000	000	31	000	22	000	000	87	18	000	000
                            65	000	000	000	43	54	000	000	76	76	43	55	000	000	000	64	000	000
                            000	36	25	000	47	000	58	000	000	25	000	47	36	000	000	000	58	000
                            000	000	000	23	81	000	78	000	12	000	12	000	000	81	000	23	78	000
                            000	000	000	000	56	67	34	000	45	67	000	34	56	45	000	000	000	000
                            000	000	000	43	000	65	76	54	000	000	000	000	000	000	54	65	76	43
                            65	43	76	000	54	000	000	000	000	54	000	000	000	76	65	000	43	000
                            000	000	52	000	000	000	74	85	63	000	74	000	000	52	63	000	000	85
                            47	25	36	58	000	000	000	000	000	58	25	47	000	36	000	000	000	000
                            000	36	47	000	25	000	000	000	58	58	000	000	000	25	000	000	47	36
                            000	12	81	000	000	23	78	000	000	000	000	23	000	000	000	78	12	81
                            000	36	000	000	25	58	000	000	47	000	58	25	000	000	47	000	36	000
                            000	67	000	000	000	56	45	34	000	34	000	45	56	000	000	000	67	000
                            74	000	000	52	63	85	000	000	000	000	74	000	000	000	000	52	63	85
                            000	34	000	000	45	67	000	000	56	000	34	67	000	000	56	000	000	45
                            27	16	38	000	000	000	41	000	000	38	000	000	16	000	000	000	41	27
                            12	000	81	000	000	000	78	23	000	23	000	78	81	000	12	000	000	000
                            21	87	18	000	000	32	000	000	000	000	18	32	000	000	000	000	87	21}';
end

% Modifico Nombres de la matriz para que en vez de numeros tengan los
% nombres de las imagenes y ya callearlas de esta database directamente
DummyStimuliDir = {PerceptionStimuliDir(:,1).name}';
stim.Perception_Stimuli_Dummy = stim.Task_ShapeColor_Stimuli;
for ReplaceStimuli = 1:size(DummyStimuliDir,1)
    % Defino en cada imagen en que indices se encuentran los numeros en el
    % nombre
    %% Contadores para poner a punto los nombres de los estimulos
    Counter = 1;
    Deletion = 1;
    Num = regexp(stim.PerceptionStimuliDir(ReplaceStimuli,1).name,'\d');
    Length_Num = length(Num);
    % Itero por cada letra
    for Del_Letters = 1:size(DummyStimuliDir{ReplaceStimuli,1},2)
        % Como es secuencial no hay problema en saltearse numeros
        if  Counter ~= Length_Num + 1  && Del_Letters == Num(Counter)
            Counter = Counter + 1;
            Deletion = Deletion + 1;
        else
            DummyStimuliDir{ReplaceStimuli,1}(Deletion) = [];
        end
    end
    % Reemplazo los numeros con el nombre de las imagenes (Hagase notar que
    % deben tener numeros incluidos en el nombre para que funcione.
    ReplaceList = find([stim.Perception_Stimuli_Dummy{:}] == str2double(DummyStimuliDir{ReplaceStimuli,1}));
    for ReplaceIter = 1:length(ReplaceList)
        stim.Task_ShapeColor_Stimuli{ReplaceList(ReplaceIter)} = stim.PerceptionStimuliDir(ReplaceStimuli,1).name;
    end
end
clear Counter Deletion Num Length_Num Deletion ReplaceList DummyStimuliDir

%%%%%%%%%% FIN ESTIMULOS SHAPECOLOR %%%%%%%


end






