 function InteroPriming_EEG()

clc;
sca;
close all;
clearvars;
clear all;

%% LIBRERIAS 

addpath('lib');
addpath(genpath('D:\PsychoPy3.2\Lib\site-packages\psychtoolbox'))
%% CONSTANTES 

global TAMANIO_INSTRUCCIONES
global TAMANIO_TEXTO
global EEG
global pportobj pportaddr MARCA_DURACION

MARCA_DURACION = 1e-3;

EEG = false;

TAMANIO_TEXTO = 0.05;
TAMANIO_INSTRUCCIONES = 0.03; 

TIEMPO_MOTOR_PRACTICA = 30;
TIEMPO_MOTOR = 120;

%% PUERTO PARALELO

if EEG
    pportaddr = 'C020';

    if exist('pportaddr','var') && ~isempty(pportaddr)
        fprintf('Connecting to parallel port 0x%s.\n', pportaddr);
        pportaddr = hex2dec(pportaddr);

        pportobj = io64;
        io64status = io64(pportobj);

        EnviarMarca(0);
        
        if io64status ~= 0
            error('io64 failure: could not initialise parallel port.\n');
        end
    end
end

%% TECLAS

KbName('UnifyKeyNames');
teclas.ExitKey = KbName('ESCAPE');
teclas.LatidosKey = KbName('Z'); 
teclas.botones_salteado = [KbName('P') KbName('Q')];
teclas.RightKey = KbName('RightArrow');
teclas.LeftKey = KbName('LeftArrow');
teclas.DownKey = KbName('DownArrow');
teclas.UpKey = KbName('UpArrow');
teclas.EnterKey = KbName('DownArrow');  
teclas.Continuar = KbName('SPACE');

teclas.emociones = {KbName('LeftArrow') KbName('DownArrow') KbName('RightArrow')};
emociones_textos_botones = {'Negativa' 'Neutral' 'Positiva'; 'izquierda' 'abajo' 'derecha'};

log.emociones.textos_botones = emociones_textos_botones;

 
%% NOMBRE DEL PACIENTE

nombre = inputdlg('Nombre:');
nombre = nombre{1};

%% ORDEN DE INTERO - EXTERO

opciones = {'Intero-Extero' 'Extero-Intero'};
choice = menu('Orden:', opciones);
if choice == 2
    secuencia_actual.intero = {'motor' 'intero' 'motor' 'intero'};
else
    secuencia_actual.intero = {'intero' 'motor' 'intero' 'motor'};
end

%% SECUENCIA DE EMOCIONES
% load(fullfile('data','secuencias.mat'))
% cantidad_secuencias = size(secuencias,1);
% numero_secuencia = NaN;
% while numero_secuencia < 1 || numero_secuencia > cantidad_secuencias || isnan(numero_secuencia)
%     numero_secuencia = inputdlg(sprintf('N� de secuencia (1 al %d):', cantidad_secuencias));
%     numero_secuencia  = str2double(numero_secuencia{1});
% end
% 
% secuencia_actual.emociones = secuencias(numero_secuencia,:);
secuencia_actual.emociones = 'ABCD';

%% PSYCHOTOOLBOX
exit = false;

hd = init_psych;

%% LOG
log.secuencia = secuencia_actual;
log.nombre = nombre;


%% CARGO DATOS DE INTERO

log.intero = cell(length(secuencia_actual.intero),1);
intero.bloques = cell(length(secuencia_actual.intero),1);
intero.marcas = cell(length(secuencia_actual.intero),1);

contador_intero = 1;
contador_motor = 1;
intero_dir = fullfile('data','intersujeto');
for i = 1:length(secuencia_actual.intero)

    bloque = secuencia_actual.intero{i};
    data_dir = fullfile(intero_dir, bloque);
    
    if strcmp(bloque, 'motor')
        intero.bloques{i} = CargarBloqueInteroMotor(data_dir, contador_motor);    
        marca.inicio = contador_motor + 200;
        marca.fin = contador_motor * 11 + 200;
        marca.respuesta = 100 + contador_motor;
        contador_motor = contador_motor + 1;
    else
        intero.bloques{i} = CargarBloqueInteroMotor(data_dir, contador_intero);
        marca.inicio = (contador_intero+2)  + 200;        
        marca.fin = (contador_intero+2) * 11 + 200;
        marca.respuesta = 100 + (contador_intero+2);        
        contador_intero = contador_intero + 1;        
    end
    
    
    intero.marcas{i} = marca;
    
end

practica_dir = fullfile(intero_dir, 'practica');
intero.practica = CargarBloqueInteroMotor(practica_dir, 1);

%% CARGO DATOS DE EMOCIONES

% MAPA CON LAS IMAGENES CORRESPONDIENTES A CADA CODIGO
emociones_dir = fullfile('data','emociones');
directorio_imagenes = fullfile(emociones_dir,'imagenes');
bloques_dir = fullfile(emociones_dir,'bloques');

keySet = ArchivosDeCarpeta(directorio_imagenes);
valueSet = CargarTexturas(directorio_imagenes, keySet, hd.window);
map = containers.Map(keySet,valueSet);

emociones.codigos = containers.Map(keySet, 1:length(keySet)); % le asigna un numero a cada imagen para enviar como marca
log.emociones = cell(length(secuencia_actual.emociones), 1);
emociones.texturas = cell(length(secuencia_actual.emociones),1);
emociones.archivos = cell(length(secuencia_actual.emociones),1);
for i = 1:length(emociones.texturas)
    bloque = secuencia_actual.emociones(i);
    archivo = CargarArchivo(fullfile(bloques_dir, [bloque '.dat']));
    [emociones.texturas{i}, emociones.archivos{i}] = Decodificar(archivo, map);
    log.emociones{i} = cell(length(emociones.texturas{i}),1);
end

emociones.instrucciones = fileread(fullfile(emociones_dir,'instrucciones.txt'));
emociones.textos_botones = emociones_textos_botones;

practica_dir = fullfile(emociones_dir, 'practica');
emociones_practica.instrucciones = emociones.instrucciones;
emociones_practica.mensaje_practica =  fileread(fullfile(emociones_dir,'mensaje_practica.txt'));
emociones_practica.texturas = CargarTexturasDeCarpeta(practica_dir, hd.window);
emociones_practica.texturas = emociones_practica.texturas(randperm(numel(emociones_practica.texturas)));
emociones_practica.texturas = {emociones_practica.texturas};
emociones_practica.duraciones = 0.2;
emociones_practica.textos_botones = emociones.textos_botones;

%% INSTRUCCIONES PRINCIPALES
instrucciones = CargarTextosDeCarpeta(fullfile('data','instrucciones'));
for x = 1:length(instrucciones)
    TextoCentrado(instrucciones{x}, TAMANIO_INSTRUCCIONES, hd);
    Screen('Flip',hd.window);
    exit = EsperarBoton(teclas.Continuar, teclas.ExitKey);
    if exit
        Salir(hd);
        return;
    end
end
    

%% PRACTICAS
exit = false;
[~, exit] = CorrerSecuenciaIntero(intero.practica, teclas, hd, TIEMPO_MOTOR_PRACTICA, true, []);
if exit
    Salir(hd);
    return
end

[~, exit] = CorrerSecuenciaEmociones(emociones_practica, 1, hd, teclas, []);
if exit
    Salir(hd);
    return
end

%% PARADIGMA
log_file = PrepararLog('log', nombre, 'InteroPriming');

for i = 1:length(secuencia_actual.intero)
    [log.intero{i}, exit] = CorrerSecuenciaIntero(intero.bloques{i}, teclas, hd, TIEMPO_MOTOR, false, intero.marcas{i});
    save(log_file, 'log');
    if exit
        break;
    end
    [log.emociones{i}, exit] = CorrerSecuenciaEmociones(emociones, i, hd, teclas, log.emociones{i});
    save(log_file, 'log');
    if exit
        break;
    end
    [log.preguntas{i}, exit] = BloquePreguntas(hd, teclas);
    save(log_file, 'log');
    if exit
        break;
    end    
    
end

TextoCentrado('Usted lo hizo muy bien, gracias por participar', TAMANIO_INSTRUCCIONES, hd, hd.white);
Screen('Flip',hd.window);


WaitSecs(2);

%% SALIR
Salir(hd);
end