function texto = AgregarFinLinea(str, largo)

    while str(end) == ' ' || str(end) == char(10)
        str(end) = [];
    end

    palabras = regexp(str,' ', 'split');

    texto = [];
    linea = [];
    contador = 0;
    for i = 1:length(palabras)
        if contador + length(palabras{i}) + 1 > largo

            texto = [texto char(10) linea];

            contador = length(palabras{i});
            linea = [palabras(i)];
        else
            if (i == 1)
                linea = [palabras(i)];
                contador = length(palabras{i});
            else
                linea = [linea ' ' palabras(i)];
                contador = contador + length(palabras{i}) + 1;
            end

        end
    end
    if i == 1
        texto = linea;
    else
        texto = [texto char(10) linea];
    end
    
    texto = strjoin(texto, '');
    if (texto(1) == char(10))
        texto(1) = [];
    end
end