function [stim, dirs] = Memory_Binding_Stimuli_Position(stim, design, ptb, dirs)
% Creates a matrix for stimulus presentation.
% The matrix has all trials, positions, and images names.
% Inputs: stim, design, ptb, dirs
% Outputs: stim, dirs
% Orig: INECO; Mod: PRG 11/2019


%%%%%%%%%%%%%%% INICIO CREACION TABLA PERCEPCION %%%%%%%%%%%%%%%
% Defino Tabla Percepcion como cell y agrego headers de Width y Height
stim.Stimuli_Perception_Database      = {};
stim.Stimuli_Task_ShapeOnly_Database  = {};
stim.Stimuli_Perception_Database{1,1} = 'Position_Width';
stim.Stimuli_Perception_Database{1,2} = 'Position_Height';

% Defino cantidad de Trials Para las tareas
for a = 1:design.nTrials
    stim.Stimuli_Perception_Database{1,a + 2}     = ['Trial_', num2str(a)];
    stim.Stimuli_Task_ShapeOnly_Database{1,a + 2} = ['Trial_', num2str(a)];
end

% Define Distancias para posicionar las imagenes segun porcentajes de
% pantalla de E-Prime para tarea de percepcion
stim.Screen_Height_Start = ceil(ptb.w.H*41/100);
stim.Screen_Width_Start  = ceil(ptb.w.W*31/100);

% Tamanio de imagenes e intervalos entre fin e inicio de imagen
stim.Screen_Height_Intervals = ceil(ptb.w.H*2/100);
stim.Screen_Height_Size      = ceil(ptb.w.H*5/100);
stim.Screen_Width_Intervals  = ceil(ptb.w.W*2/100);
stim.Screen_Width_Size       = ceil(ptb.w.W*4/100);

% Black bar
stim.Midpoint_Width          = ceil(ptb.w.W*11/100);
stim.Midpoint_Bar_Place      = ceil(ptb.w.W*50/100);

% Mitad de los dos cuadrados en tarea de percepcion
mitad = 0;

% Defino Posiciones de percepcion en la pantalla y los agrego a la tabla de
% posiciones y estimulos para percepcion
for a = 1:2
    widthCounter = 0;
    if a == 2
        mitad = 1;
    end
    for b = 1:9
        widthCounter = widthCounter + 1;
        if mitad ~= 1
            if b == 1
                stim.Stimuli_Perception_Database{b+1,1} = stim.Screen_Width_Start;
                stim.Stimuli_Perception_Database{b+1,2} = stim.Screen_Height_Start;
            else
                if widthCounter ~= 4
                    stim.Stimuli_Perception_Database{b+1,2} = stim.Stimuli_Perception_Database{b,2} + stim.Screen_Height_Size + stim.Screen_Height_Intervals;
                    stim.Stimuli_Perception_Database{b+1,1} = stim.Stimuli_Perception_Database{b,1};
                else
                    stim.Stimuli_Perception_Database{b+1,2} = stim.Stimuli_Perception_Database{2,2};
                    stim.Stimuli_Perception_Database{b+1,1} = stim.Stimuli_Perception_Database{b,1} + stim.Screen_Width_Size + stim.Screen_Width_Intervals;
                    widthCounter = 1;
                end
            end
        else
            if b == 1
                stim.Stimuli_Perception_Database{b+10,1} = stim.Stimuli_Perception_Database{b+9,1} + stim.Midpoint_Width;
                stim.Stimuli_Perception_Database{b+10,2} = stim.Stimuli_Perception_Database{2,2};
            else
                if widthCounter ~= 4
                    stim.Stimuli_Perception_Database{b+10,2} = stim.Stimuli_Perception_Database{b+9,2} + stim.Screen_Height_Size + stim.Screen_Height_Intervals;
                    stim.Stimuli_Perception_Database{b+10,1} = stim.Stimuli_Perception_Database{b+9,1};
                else
                    stim.Stimuli_Perception_Database{b+10,2} = stim.Stimuli_Perception_Database{2,2};
                    stim.Stimuli_Perception_Database{b+10,1} = stim.Stimuli_Perception_Database{b+9,1} + stim.Screen_Width_Size + stim.Screen_Width_Intervals;
                    widthCounter = 1;
                end
            end
        end
    end
end

% Posicion de barra de donde a donde (despues se modifica a gusto para el
% largo deseado
stim.Min_Bar = 1;
for width_max_min = 2:length(stim.Stimuli_Perception_Database(:,1))
    stim.Min_Bar(width_max_min-1,2) = stim.Stimuli_Perception_Database{width_max_min,2};
    stim.Min_Bar(width_max_min-1,1) = stim.Stimuli_Perception_Database{width_max_min,1};
end

%%%%%%%%%%%%%%% FIN CREACION TABLA PERCEPCION %%%%%%%%%%%%%%%

%%%%%%%%%%%%%%% INICIO CREACION TABLAS TAREAS %%%%%%%%%%%%%%%
% Defino Tabla como cell y agrego headers de Width y Height
stim.Stimuli_Task_ShapeOnly_Database{1,1} = 'Position_Width';
stim.Stimuli_Task_ShapeOnly_Database{1,2} = 'Position_Height';

% Define Distancias para posicionar las imagenes segun porcentajes de
% pantalla de E-Prime para las tareas
stim.Screen_Task_Height_Start = ceil(ptb.w.H*44/100);
stim.Screen_Width_Start       = ceil(ptb.w.W*45/100);

% Defino Posiciones de estimulos en la pantalla y los agrego a la tabla de
% posiciones y estimulos para las tareas
widthCounter = 0;
for b = 1:9
    widthCounter = widthCounter + 1;
    if b == 1
        stim.Stimuli_Task_ShapeOnly_Database{b+1,1} = stim.Screen_Width_Start;
        stim.Stimuli_Task_ShapeOnly_Database{b+1,2} = stim.Screen_Task_Height_Start;
    else
        if widthCounter ~= 4
            stim.Stimuli_Task_ShapeOnly_Database{b+1,2} = stim.Stimuli_Task_ShapeOnly_Database{b,2} + stim.Screen_Height_Size + stim.Screen_Height_Intervals;
            stim.Stimuli_Task_ShapeOnly_Database{b+1,1} = stim.Stimuli_Task_ShapeOnly_Database{b,1};
        else
            stim.Stimuli_Task_ShapeOnly_Database{b+1,2} = stim.Stimuli_Task_ShapeOnly_Database{2,2};
            stim.Stimuli_Task_ShapeOnly_Database{b+1,1} = stim.Stimuli_Task_ShapeOnly_Database{b,1} + stim.Screen_Width_Size + stim.Screen_Width_Intervals;
            widthCounter = 1;
        end
    end
end
stim.Stimuli_Task_ShapeOnly_Database(11:19,2) = stim.Stimuli_Task_ShapeOnly_Database(2:10,2);
stim.Stimuli_Task_ShapeOnly_Database(11:19,1) = stim.Stimuli_Task_ShapeOnly_Database(2:10,1);
%%%%%%%%%%%%%%% FIN CREACION TABLAS TAREAS %%%%%%%%%%%%%%%

%% Ordeno los estimulos, y los agrego a las Tablas
[stim] = Stimuli_Order_WM(stim, dirs, design);

stim.Stimuli_Task_ShapeColor_Database = stim.Stimuli_Task_ShapeOnly_Database;
stim.Stimuli_Task_ShapeOnly_Database(2:end,3:end) = stim.Task_ShapeOnly_Stimuli;
stim.Stimuli_Task_ShapeColor_Database(2:end,3:end) = stim.Task_ShapeColor_Stimuli;


end

