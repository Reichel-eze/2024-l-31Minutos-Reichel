% Parcial 31 Minutos

% ------ CANCIONES -------

% Cancion, Compositores,  Reproducciones
cancion(bailanSinCesar, [pabloIlabaca, rodrigoSalinas], 10600177).
cancion(yoOpino, [alvaroDiaz, carlosEspinoza, rodrigoSalinas], 5209110).
cancion(equilibrioEspiritual, [danielCastro, alvaroDiaz, pabloIlabaca, pedroPeirano, rodrigoSalinas], 12052254).
cancion(tangananicaTanganana, [danielCastro, pabloIlabaca, pedroPeirano], 5516191).
cancion(dienteBlanco, [danielCastro, pabloIlabaca, pedroPeirano], 5872927). 
cancion(lala, [pabloIlabaca, pedroPeirano], 5100530).
cancion(meCortaronMalElPelo, [danielCastro, alvaroDiaz, pabloIlabaca, rodrigoSalinas], 3428854).

% Mes, Puesto, Cancion
rankingTop3(febrero, 1, lala).
rankingTop3(febrero, 2, tangananicaTanganana).
rankingTop3(febrero, 3, meCortaronMalElPelo).
rankingTop3(marzo, 1, meCortaronMalElPelo).
rankingTop3(marzo, 2, tangananicaTanganana).
rankingTop3(marzo, 3, lala).
rankingTop3(abril, 1, tangananicaTanganana).
rankingTop3(abril, 2, dienteBlanco).
rankingTop3(abril, 3, equilibrioEspiritual).
rankingTop3(mayo, 1, meCortaronMalElPelo).
rankingTop3(mayo, 2, dienteBlanco).
rankingTop3(mayo, 3, equilibrioEspiritual).
rankingTop3(junio, 1, dienteBlanco).
rankingTop3(junio, 2, tangananicaTanganana).
rankingTop3(junio, 3, lala).

% 1) Saber si una canción es un hit, lo cual ocurre si aparece en el 
% ranking top 3 de todos los meses.

hit(Cancion) :-
    cancion(Cancion, _, _),
    forall(mes(Mes), rankingTop3(Mes, _, Cancion)).
    
mes(Mes) :- rankingTop3(Mes, _, _).

% 2) Saber si una canción no es reconocida por los críticos, 
% lo cual ocurre si tiene muchas reproducciones y nunca 
% estuvo en el ranking. Una canción tiene muchas reproducciones 
% si tiene más de 7000000 reproducciones.

noEsReconocidaPorLosCriticos(Cancion) :-
    cantidadDeReproducciones(Cancion, Cantidad),
    Cantidad > 7000000,
    not(rankingTop3(_,_,Cancion)).

noEsReconocidaPorLosCriticosV2(Cancion) :-
    tieneMuchasReproducciones(Cancion),
    not(rankingTop3(_,_,Cancion)).

noEsReconocidaPorLosCriticosV3(Cancion) :-
    cancion(Cancion, _, Cantidad),
    Cantidad > 7000000,
    not(rankingTop3(_,_,Cancion)).

cantidadDeReproducciones(Cancion, Cantidad) :- 
    cancion(Cancion, _, Cantidad).

tieneMuchasReproducciones(Cancion) :-
    cantidadDeReproducciones(Cancion, Cantidad),
    Cantidad > 7000000.

% 3) Saber si dos compositores son colaboradores, lo cual ocurre
% si compusieron alguna canción juntos.

sonColaboradores(Compositor, OtroCompositor) :-
    cancion(_, Compositores, _),
    member(Compositor, Compositores),
    member(OtroCompositor, Compositores),
    Compositor \= OtroCompositor.

sonColaboradoresV2(Compositor, OtroCompositor) :-
    cantaEn(Compositor, Cancion),
    cantaEn(OtroCompositor, Cancion),
    Compositor \= OtroCompositor.

cantaEn(Compositor, Cancion) :-
    cancion(Cancion, Compositores, _),
    member(Compositor, Compositores).

% ------ TRABAJOS -------

% Tipos de trabajos que existen    
% Los conductores, de los cuales nos interesa sus años de experiencia.
% Los periodistas, de los cuales nos interesa sus años de experiencia y su título, el cual puede ser licenciatura o posgrado. 
% Los reporteros, de los cuales nos interesa sus años de experiencia y la cantidad de notas que hicieron a lo largo de su carrera.

% 4) Modelar en la solución a los siguientes trabajadores:

trabajador(tulio, conductor(5)).
trabajador(bodoque, periodista(2, licenciatura)).
trabajador(bodoque, reportero(5, 300)).
trabajador(marioHugo, periodista(10, posgrado)).
trabajador(juanin, conductor(0)).

% AGREGO NUEVOS TRABAJOS!!
trabajador(ezequiel, barista(1, [expreso, americano, macchiato])).
trabajador(marcela, barista(1, [cortado])).

% barista(Anios de Experiencia, CafesQueSabeHacer)

% 5) Conocer el Sueldo Total de una persona, el cual está dado por 
% la suma de los sueldos de cada uno de sus trabajos

sueldoTotal(Persona, SueldoTotal) :-
    trabajador(Persona, _),
    findall(Sueldo, (trabajador(Persona, Trabajo), sueldo(Trabajo, Sueldo)), Sueldos),
    sum_list(Sueldos, SueldoTotal).

sueldoSegunTrabajo(Persona, Sueldo) :-
    trabajador(Persona, Trabajo),
    sueldo(Trabajo, Sueldo).

% EL SUELDO SE CALCULA SEGUN EL TRABAJO
sueldo(conductor(AniosExp), Sueldo) :- Sueldo is AniosExp * 10000.
sueldo(reportero(AniosExp, CantNotas), Sueldo) :- Sueldo is AniosExp * 10000 + CantNotas * 100.

%sueldo(periodista(Anios, licenciatura), Sueldo) :-
%    SueldoExperiencia is Anios * 5000,
%    Sueldo is SueldoExperiencia * 1.20.

%sueldo(periodista(Anios, posgrado), Sueldo) :-
%    SueldoExperiencia is Anios * 5000,
%    Sueldo is SueldoExperiencia * 1.35.

% Esto si lo quiero hacer sin repeticion de logica

sueldo(periodista(AniosExp, Titulo), Sueldo) :-
    aumentoSegunTitulo(Titulo, Porcentaje),
    Sueldo is AniosExp * 5000 * (1 + Porcentaje/100).

sueldo(barista(AniosExp, ListaDeCafes), Sueldo) :-
    aumentoSegunCantidadDeCafes(ListaDeCafes, Aumento),
    Sueldo is AniosExp * 3000 + Aumento.

aumentoSegunCantidadDeCafes(ListaDeCafes, 0) :-
    length(ListaDeCafes, Cantidad),
    between(0, 1, Cantidad).
    
aumentoSegunCantidadDeCafes(ListaDeCafes, 10000) :-
    length(ListaDeCafes, Cantidad),
    Cantidad >= 2.

aumentoSegunTitulo(licenciatura, 20).
aumentoSegunTitulo(posgrado, 35).

% 6) Agregar un nuevo trabajador que tenga otro tipo de trabajo 
% nuevo distinto a los anteriores. Agregar una forma de calcular 
% el sueldo para el nuevo trabajo agregado ¿Qué concepto de la 
% materia se puede relacionar a esto?

% LO VOY A AGREGAR ARRIBA!!

% Graicas Al polimorfismo puedo agregar otros trabajos (siguiendo con
% el uso del predicado trabajador) y el sueldo correspondiente segun
% el trabajo (el como se calcula) sin tener que modificar otra parte
% del codigo, permitiendo la reutilizacion de logica (por ej, el predicado
% sueldo/2)

% Agrege el tipo de trabajo barista, lo cual es un ejemplo de cómo se puede extender el sistema utilizando 
% el concepto de polimorfismo. Gracias a este concepto, puedes agregar otros tipos de trabajo y sus respectivos cálculos de sueldo
% sin necesidad de modificar las otras partes del código.

% El concepto que se relaciona aquí es el polimorfismo, que en este caso te permite definir nuevos tipos de trabajo y calcular sus sueldos 
% de manera independiente, reutilizando el mismo predicado sueldo/2 para diferentes trabajos.

% Resumen
% - Polimorfismo: Te permite agregar nuevos tipos de trabajo y sus respectivos cálculos de sueldo sin modificar otras partes del código.
% - Extensibilidad: El código es fácil de extender con nuevos tipos de trabajo.
% - Reutilización de lógica: La función sueldo/2 se reutiliza para diferentes trabajos, simplificando el código.