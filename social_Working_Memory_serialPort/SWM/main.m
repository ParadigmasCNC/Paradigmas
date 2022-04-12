%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SWM Pardigm V3.1 
%
% This script is a working memory task that uses words as stimulus
% 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
clear
close all
Screen('Preference', 'SkipSyncTests', 1);

% Patient info
name = input('Ingrese el codigo del paciente: ', 's');
date = datestr(now);
edad = input('Ingrese la edad del paciente:' , 's');

log.name = name;
log.date = date;
log.edad = edad;

global EEG
global pportobj pportaddr MARCA_DURACION
MARCA_DURACION = 1e-3;


EEGcheck = menu('Using EEG?','Yes','No');
if EEGcheck == 1; EEG = true; log.EEG = 'Yes'; else EEG = false; log.EEG = 'No'; end


%% PUERTO PARALELO
marca = struct;
if EEG
    %pportaddr = '00000001'; %ok
    %if exist('pportaddr','var') && ~isempty(pportaddr)
        fprintf('Connecting to parallel port %s.\n', 'COM3');
        %pportaddr = hex2dec(pportaddr);
        %pportaddr = hex2dec('378')
        pportobj = serialport('COM3',38400); % Use this for debugging clear pportobj pportaddr

        %fclose(pportobj)
        %pportobj = io64;
        %io64status = io64(pportobj);       
        %if io64status ~= 0
        %    error('io64 failure: could not initialise parallel port.\n');
        %end
    %end
    
   % Marcas
    marca.FixCrossStart       = 10;
    marca.FixCrossEnd         = 11;
    marca.inicioPrueba        = 242;
    marca.FinPrueba           = 252;
    marca.inicioTarea         = 241;
    marca.FinTarea            = 251;
    marca.inicioBloque        = 101;
    marca.finBloque           = 111;
    marca.estimuloTres        = 30;
    marca.estimuloTresC       = 31;
    marca.estimuloTresIc      = 32;
    marca.estimuloCuatro      = 40;
    marca.estimuloCuatroC     = 41;
    marca.estimuloCuatroIc    = 42;
    marca.estimuloCinco       = 50;
    marca.estimuloCincoC      = 51;
    marca.estimuloCincoIc     = 52;
    marca.estimuloTresFin     = 60;
    marca.estimuloTresCFin    = 61;
    marca.estimuloTresIcFin   = 62;
    marca.estimuloCuatroFin   = 70;
    marca.estimuloCuatroCFin  = 71;
    marca.estimuloCuatroIcFin = 72;
    marca.estimuloCincoFin    = 80;
    marca.estimuloCincoCFin   = 81;
    marca.estimuloCincoIcFin  = 82;
    marca.no = 1;
    marca.si = 2;
    log.marcas = marca;
end

%% Configure constant and variables (log), Load images

hd.itemsize = 100;
hd.wsize = (hd.itemsize/2)+30;
hd.textsize = 35;
hd.textfont = 'Helvetica';

iti.xmin=200;   % Random ITI limits
iti.xmax=500;

% Production 

hd.times(1).stim  = 3000/1000;
hd.times(1).blank = 5000/1000;
hd.times(1).test  = inf; %4500/1000;

hd.times(2).stim  = 4000/1000;
hd.times(2).blank = 5000/1000;
hd.times(2).test  = inf; %5500/1000;

hd.times(3).stim  = 5000/1000;
hd.times(3).blank = 5000/1000;
hd.times(3).test  = inf; %6500/1000;

%Debug
% hd.times(1).stim= 30/1000;
% hd.times(1).blank= 50/1000;
% hd.times(1).test= 10/1000;
% 
% hd.times(2).stim=40/1000;
% hd.times(2).blank= 50/1000;
% hd.times(2).test= 10/1000;
% 
% hd.times(3).stim= 50/1000;
% hd.times(3).blank= 50/1000;
% hd.times(3).test= 10/1000;
% 

point=1;    % word pointer


Intro = imread('Images/Bienvenida.jpg');
Test_start = imread('Images/Test_start.jpg');
[~,~, raw]=xlsread('Words/Estimulos_SWM.xls');


%% Start Psychtoolbox - FINISHED

PsychDefaultSetup(2);
HideCursor();
Priority(max(Priority));

%% Configure Screen - FINISHED

% Get the screen numbers. This gives us a number for each of the screens
% attached to our computer.
screens = Screen('Screens');

% To draw we select the maximum of these numbers. So in a situation where we
% have two screens attached to our monitor we will draw to the external
% screen.
screenNumber = max(screens);

% Define black and white (white will be 1 and black 0). This is because
% in general luminace values are defined between 0 and 1 with 255 steps in
% between. All values in Psychtoolbox are defined between 0 and 1

hd.white = WhiteIndex(screenNumber);
hd.black = BlackIndex(screenNumber);
 


%% Present Test to patient

% Open an on screen window using PsychImaging and color it grey.
[window, scrnsize] = PsychImaging('OpenWindow', screenNumber, hd.black);

hd.window=window;
hd.centerx = scrnsize(3)/2;
hd.centery = scrnsize(4)/2;
hd.bottom = scrnsize(4);
hd.right = scrnsize(3);

Screen('TextSize', hd.window, hd.textsize);
Screen('TextFont', hd.window, hd.textfont);       

%% Present Test to patient
if EEG
    EnviarMarca(marca.inicioTarea);
end
textureIndex=Screen('MakeTexture', hd.window, Intro);
Screen('DrawTexture', hd.window, textureIndex);

Screen('Flip',hd.window);
[~, keyCode,~] = KbStrokeWait; %#ok

%% Practice
numberoftrials2run = 10;
log.PracticeTrials = numberoftrials2run;
if EEG
    EnviarMarca(marca.inicioPrueba);
end

[log_practice point]=trials_run(numberoftrials2run,hd,iti,raw,point,name,date,EEG,marca);%#ok
log.PracticeInfo = log_practice;
if EEG
    EnviarMarca(marca.FinPrueba);
end

black=hd.black;
Screen('FillRect',hd.window,black);                   
textureIndex=Screen('MakeTexture', hd.window, Test_start);
Screen('DrawTexture', hd.window, textureIndex);
Screen('Flip',hd.window);


[~, keyCode,~] = KbStrokeWait;

%if keycode == r re run the practice

while(find(keyCode) == KbName('r'))

    textureIndex=Screen('MakeTexture', hd.window, Intro);
    Screen('DrawTexture', hd.window, textureIndex);
    Screen('Flip',hd.window);

    [~, keyCode,~] = KbStrokeWait;
    
    if (find(keyCode) == KbName('q'))
        
        Screen('CloseAll'); % Cierro ventana del Psychtoolbox
        error('Finalizando script...')
        
    end
    
    numberoftrials2run=6;
    log.RepeatPracticeTrials = numberoftrials2run;
    if EEG
        EnviarMarca(marca.inicioPrueba);
    end
    
    [log_practice, ~]=trials_run(numberoftrials2run,hd,iti,raw,point,name,date,EEG,marca);
    log.RepeatPracticeInfo = log_practice;
    if EEG
        EnviarMarca(marca.FinPrueba);
    end
    black=hd.black;
    Screen('FillRect',hd.window,black)  ;
    textureIndex=Screen('MakeTexture', hd.window, Test_start);
    Screen('DrawTexture', hd.window, textureIndex);
    Screen('Flip',hd.window);
    [~, keyCode,~] = KbStrokeWait;

end

%% Test
numberoftrials2run = 50;
log.TestTrials = numberoftrials2run;
if EEG
    EnviarMarca(marca.inicioBloque);
end

[log_test point]=trials_run(numberoftrials2run,hd,iti,raw,point,name,date,EEG,marca);%#ok
log.TestResponses = log_test;
if EEG
    EnviarMarca(marca.finBloque);
end
%% Save & Close
Screen('Flip',hd.window);
goodbyeText = DrawFormattedText(hd.window,'¡Eso fue todo! Gracias por participar del experimento', 'center','center',hd.white);
Screen('Flip',hd.window,goodbyeText);
[~, keyCode,~] = KbStrokeWait;
save(['Log/' name '_' date(1:11) '_SWM.mat'],'log');
if EEG
    EnviarMarca(marca.FinTarea);
end
Screen('CloseAll'); % Cierro ventana del Psychtoolbox
