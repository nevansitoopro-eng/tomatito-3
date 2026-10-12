<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Para mi niña linda ♡</title>
    <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@400;600;700&family=Montserrat:wght@300;400;500;600&family=Press+Start+2P&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            user-select: none;
        }

        body, html {
            width: 100%;
            height: 100%;
            overflow: hidden;
            background-color: #030106;
            font-family: 'Montserrat', sans-serif;
            color: #fff;
        }

        canvas#universo {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: 1;
        }

        canvas#corazones-canvas {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: 100;
            pointer-events: none;
        }

        /* POPUP MENSAJE SECRETO ESTRELLA FUGAZ */
        .popup-secret {
            position: fixed;
            top: 20%;
            left: 50%;
            transform: translate(-50%, -20%) scale(0.8);
            z-index: 200;
            background: rgba(255, 230, 240, 0.95);
            border: 3px solid #ff4d8d;
            border-radius: 16px;
            padding: 16px 20px;
            color: #801d41;
            text-align: center;
            box-shadow: 0 0 30px rgba(255, 77, 141, 0.8);
            backdrop-filter: blur(8px);
            opacity: 0;
            pointer-events: none;
            transition: all 0.4s ease;
            max-width: 320px;
            width: 85%;
        }

        .popup-secret.visible {
            opacity: 1;
            pointer-events: all;
            transform: translate(-50%, -20%) scale(1);
        }

        .popup-secret h3 {
            font-family: 'Press Start 2P', cursive;
            font-size: 0.65rem;
            color: #b32d5c;
            margin-bottom: 10px;
        }

        .popup-secret p {
            font-size: 0.85rem;
            line-height: 1.5;
            color: #4a1525;
            margin-bottom: 12px;
        }

        .btn-close-popup {
            background: #ff4d8d;
            color: #fff;
            border: none;
            padding: 6px 16px;
            border-radius: 12px;
            font-size: 0.75rem;
            font-weight: 600;
            cursor: pointer;
            box-shadow: 0 0 10px rgba(255, 77, 141, 0.5);
        }

        /* PANTALLA INICIAL UNIVERSO */
        .interface {
            position: relative;
            z-index: 10;
            width: 100%;
            height: 100%;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            text-align: center;
            padding: 20px;
            background: radial-gradient(circle, rgba(20,5,25,0.1) 0%, rgba(3,1,6,0.65) 100%);
            transition: opacity 1s ease, transform 1s ease;
        }

        .interface.hidden {
            opacity: 0;
            pointer-events: none;
            transform: scale(1.1);
        }

        h1.titulo-universo {
            font-family: 'Cinzel', serif;
            font-size: 2.2rem;
            letter-spacing: 5px;
            color: #ffe0e9;
            text-shadow: 0 0 20px rgba(255, 182, 193, 0.8), 0 0 40px rgba(255, 105, 180, 0.6);
            margin-bottom: 25px;
            text-transform: uppercase;
        }

        .btn-explorar {
            background: rgba(255, 192, 203, 0.18);
            border: 2px solid rgba(255, 182, 193, 0.8);
            color: #ffe6ed;
            padding: 14px 42px;
            font-size: 1rem;
            font-family: 'Cinzel', serif;
            letter-spacing: 3px;
            border-radius: 30px;
            cursor: pointer;
            box-shadow: 0 0 25px rgba(255, 182, 193, 0.5);
            transition: all 0.4s ease;
            backdrop-filter: blur(5px);
            margin-bottom: 35px;
        }

        .btn-explorar:hover {
            background: rgba(255, 192, 203, 0.4);
            border-color: #ffb6c1;
            box-shadow: 0 0 35px rgba(255, 182, 193, 0.9);
            transform: translateY(-2px);
        }

        .subtexto {
            font-size: 1rem;
            line-height: 1.8;
            color: #fce4ec;
            font-weight: 300;
            max-width: 520px;
            text-shadow: 0 0 10px rgba(255, 192, 203, 0.5);
        }

        .corazon-latido {
            margin-top: 15px;
            font-size: 1.8rem;
            color: #ff4d8d;
            animation: latido 1.5s infinite ease-in-out;
            filter: drop-shadow(0 0 10px #ff4d8d);
        }

        @keyframes latido {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.3); }
        }

        /* PASO CONTAINERS */
        .paso-container {
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%) scale(0.9);
            z-index: 20;
            opacity: 0;
            pointer-events: none;
            transition: all 0.8s ease;
            width: 90%;
            max-width: 520px;
        }

        .paso-container.visible {
            opacity: 1;
            pointer-events: all;
            transform: translate(-50%, -50%) scale(1);
        }

        /* VENTANA RETRO COMPACTA */
        .window-retro {
            background: rgba(255, 222, 235, 0.88);
            border: 3px solid #ff7fa8;
            border-radius: 18px;
            overflow: hidden;
            box-shadow: 0 0 40px rgba(255, 127, 168, 0.6);
            color: #801d41;
            text-align: center;
            backdrop-filter: blur(10px);
        }

        .window-titlebar {
            background: #ff7fa8;
            padding: 8px 12px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .window-decorations { display: flex; gap: 6px; }
        .win-btn { width: 12px; height: 12px; background: #fff; border-radius: 3px; }

        .window-content {
            padding: 18px 15px;
            background-color: rgba(255, 238, 245, 0.85);
            background-image: 
                linear-gradient(90deg, rgba(255,182,193,0.3) 1px, transparent 1px),
                linear-gradient(rgba(255,182,193,0.3) 1px, transparent 1px);
            background-size: 20px 20px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            position: relative;
        }

        .retro-title {
            font-family: 'Press Start 2P', cursive;
            font-size: 0.65rem;
            line-height: 1.6;
            color: #b32d5c;
            margin-bottom: 10px;
        }

        /* GATITO KAWAII */
        .pixel-cat-kawaii-16 {
            width: 100px;
            height: 100px;
            margin: 4px 0 12px 0;
            display: grid;
            grid-template-columns: repeat(16, 1fr);
            grid-template-rows: repeat(16, 1fr);
        }

        .pixel-cat-kawaii-16 div { width: 100%; height: 100%; }
        .cb { background: #322d38; }
        .ch { background: #ff2a6d; }
        .ce { background: #ffffff; }
        .cp { background: #120e17; }
        .cr { background: #ff9ebb; }
        .cn { background: #ffccd5; }

        .btn-group {
            display: flex;
            gap: 15px;
            align-items: center;
            justify-content: center;
            position: relative;
            width: 100%;
            min-height: 70px;
        }

        .btn-retro {
            font-family: 'Press Start 2P', cursive;
            font-size: 0.65rem;
            padding: 10px 18px;
            border: 2px dashed #ff7fa8;
            background: #ffffff;
            color: #b32d5c;
            border-radius: 10px;
            cursor: pointer;
            box-shadow: 3px 3px 0px #ff7fa8;
            z-index: 30;
            transition: transform 0.2s ease;
        }

        #btn-yes { transition: transform 0.25s ease; }
        #btn-no { position: relative; transition: left 0.2s ease, top 0.2s ease; }

        /* CARDS ESTILO GENERAL */
        .card-custom {
            background: rgba(18, 5, 16, 0.88);
            border: 1px solid rgba(255, 182, 193, 0.5);
            border-radius: 20px;
            padding: 22px 18px;
            backdrop-filter: blur(14px);
            box-shadow: 0 0 35px rgba(255, 105, 180, 0.3);
            text-align: center;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .card-custom h2 {
            font-family: 'Cinzel', serif;
            color: #ffb6c1;
            font-size: 1.4rem;
            margin-bottom: 12px;
        }

        /* CONTADOR TIEMPO EN TIEMPO REAL */
        .contador-box {
            background: rgba(255, 182, 193, 0.12);
            border: 1px solid rgba(255, 182, 193, 0.3);
            border-radius: 12px;
            padding: 8px 12px;
            margin-bottom: 12px;
            font-size: 0.8rem;
            color: #ffe0e9;
            text-shadow: 0 0 8px rgba(255, 105, 180, 0.6);
            display: flex;
            justify-content: space-around;
            align-items: center;
            width: 100%;
        }

        .contador-item {
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .contador-num {
            font-weight: 700;
            font-size: 1.05rem;
            color: #ff9ebb;
        }

        .carta-box {
            background: rgba(255, 240, 245, 0.05);
            border: 1px solid rgba(255, 192, 203, 0.2);
            border-radius: 12px;
            padding: 14px;
            text-align: left;
            font-size: 0.85rem;
            line-height: 1.6;
            color: #fce4ec;
            height: 180px;
            overflow-y: auto;
            margin-bottom: 12px;
            width: 100%;
        }

        .spotify-container {
            width: 100%;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 0 15px rgba(255, 182, 193, 0.3);
            margin-bottom: 15px;
        }

        .btn-final {
            background: #ffb6c1;
            color: #12050c;
            border: none;
            padding: 10px 24px;
            font-weight: 600;
            border-radius: 20px;
            cursor: pointer;
            font-size: 0.85rem;
            box-shadow: 0 0 15px rgba(255, 182, 193, 0.5);
            transition: all 0.3s ease;
        }

        .btn-final:hover { background: #ff8da1; }

        /* PASO BOLA DE CRISTAL INDEPENDIENTE */
        .orbe-cristal {
            width: 90px;
            height: 90px;
            border-radius: 50%;
            background: radial-gradient(circle at 30% 30%, #ffffff, #ff7fa8, #4a0e2e);
            box-shadow: 0 0 30px #ff4d8d, inset 0 0 18px #ffffff;
            cursor: pointer;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            margin: 15px 0;
            animation: flotarOrbe 3s infinite ease-in-out;
        }

        .orbe-cristal:hover {
            transform: scale(1.1);
            box-shadow: 0 0 40px #ff7fa8, inset 0 0 25px #ffffff;
        }

        @keyframes flotarOrbe {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-8px); }
        }

        .orbe-texto {
            font-size: 0.9rem;
            color: #ffe0e9;
            margin-bottom: 20px;
            font-weight: 500;
            text-shadow: 0 0 8px rgba(255, 127, 168, 0.8);
            min-height: 48px;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 0 15px;
            line-height: 1.5;
            transition: opacity 0.3s ease;
        }

        /* PASO SILUETA ABRAZO INDEPENDIENTE DETALLADO */
        .silueta-svg {
            width: 170px;
            height: 180px;
            margin: 10px 0;
            filter: drop-shadow(0 0 12px #ff4d8d) drop-shadow(0 0 22px #ff1493);
        }

        .texto-te-amo {
            font-family: 'Cinzel', serif;
            font-size: 1.8rem;
            font-weight: 700;
            color: #ffb6c1;
            letter-spacing: 5px;
            text-shadow: 0 0 20px #ff1493, 0 0 40px #ff69b4;
            margin-bottom: 20px;
        }

        #flores-canvas {
            width: 100%;
            height: 180px;
            margin-bottom: 15px;
            border-radius: 15px;
            background: rgba(10, 2, 12, 0.4);
        }
    </style>
</head>
<body>

    <canvas id="universo"></canvas>
    <canvas id="corazones-canvas"></canvas>

    <!-- POPUP DE MENSAJE SECRETO DE ESTRELLA FUGAZ -->
    <div class="popup-secret" id="popup-secreto">
        <h3>✨ DESEO ESPACIAL ✨</h3>
        <p id="texto-secreto">Mensaje secreto...</p>
        <button class="btn-close-popup" onclick="cerrarPopupSecreto()">Guardar en el corazón ♡</button>
    </div>

    <!-- PASO 1: UNIVERSO ESPACIAL DE ENTRADA -->
    <div class="interface" id="pantalla-inicio">
        <h1 class="titulo-universo">NUESTRO UNIVERSO</h1>
        <button class="btn-explorar" onclick="adentrarseEnUniverso()">EXPLORAR</button>
        <div class="subtexto">
            Mientras otros solo reaccionan historias...<br>
            yo te programé un universo
        </div>
        <div class="corazon-latido">♥</div>
    </div>

    <!-- PASO 2: VENTANA RETRO CON GATITO KAWAII -->
    <div class="paso-container" id="paso-pregunta">
        <div class="window-retro">
            <div class="window-titlebar">
                <div style="font-family: 'Press Start 2P', cursive; font-size: 0.55rem; color: #fff;">LOVE.EXE</div>
                <div class="window-decorations">
                    <div class="win-btn"></div>
                    <div class="win-btn"></div>
                    <div class="win-btn"></div>
                </div>
            </div>
            
            <div class="window-content" id="contenedor-ventana">
                <div class="retro-title" id="titulo-retro">
                    Happy 1 month, my love ♡<br>Still love me?
                </div>

                <div class="pixel-cat-kawaii-16">
                    <div></div><div></div><div class="cr"></div><div class="cr"></div><div class="cb"></div><div></div><div></div><div></div><div></div><div></div><div class="cb"></div><div class="cr"></div><div class="cr"></div><div></div><div></div><div></div>
                    <div></div><div class="cb"></div><div class="cr"></div><div class="cr"></div><div class="cr"></div><div class="cb"></div><div></div><div></div><div></div><div></div><div class="cb"></div><div class="cr"></div><div class="cr"></div><div class="cr"></div><div class="cb"></div><div></div>
                    <div></div><div class="cb"></div><div class="cr"></div><div class="cr"></div><div class="cr"></div><div class="cb"></div><div class="cb"></div><div class="cb"></div><div class="cb"></div><div class="cb"></div><div class="cb"></div><div class="cr"></div><div class="cr"></div><div class="cr"></div><div class="cb"></div><div></div>
                    <div></div><div class="cb"></div><div class="cb"></div><div class="cb"></div><div class="cb"></div><div class="cb"></div><div class="cb"></div><div class="cb"></div><div class="cb"></div><div class="cb"></div><div class="cb"></div><div class="cb"></div><div class="cb"></div><div class="cb"></div><div class="cb"></div><div></div>
                    <div class="cb"></div><div class="cb"></div><div class="cb"></div><div class="cb"></div><div class="cb"></div><div class="cb"></div><div class="cb"></div><div class="cb"></div><div class="cb"></div><div class="cb"></div><div class="cb"></div><div class="cb"></div><div class="cb"></div><div class="cb"></div><div class="cb"></div><div class="cb"></div>
                    <div class="cb"></div><div class="cb"></div><div class="ce"></div><div class="ce"></div><div class="cp"></div><div class="cp"></div><div class="cb"></div><div class="cb"></div><div class="cb"></div><div class="cb"></div><div class="ce"></div><div class="ce"></div><div class="cp"></div><div class="cp"></div><div class="cb"></div><div class="cb"></div>
                    <div class="cb"></div><div class="cb"></div><div class="ce"></div><div class="ce"></div><div class="cp"></div><div class="cp"></div><div class="cb"></div><div class="cn"></div><div class="cn"></div><div class="cb"></div><div class="ce"></div><div class="ce"></div><div class="cp"></div><div class="cp"></div><div class="cb"></div><div class="cb"></div>
                    <div class="cb"></div><div class="cr"></div><div class="cr"></div><div class="cb"></div><div class="cb"></div><div class="cb"></div><div class="cb"></div><div class="cb"></div><div class="cb"></div><div class="cb"></div><div class="cb"></div><div class="cb"></div><div class="cr"></div><div class="cr"></div><div class="cb"></div><div class="cb"></div>
                    <div></div><div class="cb"></div><div class="cb"></div><div class="cb"></div><div class="cb"></div><div class="ch"></div><div class="ch"></div><div class="cb"></div><div class="cb"></div><div class="ch"></div><div class="ch"></div><div class="cb"></div><div class="cb"></div><div class="cb"></div><div class="cb"></div><div></div>
                    <div></div><div class="cb"></div><div class="cb"></div><div class="ch"></div><div class="ch"></div><div class="ch"></div><div class="ch"></div><div class="ch"></div><div class="ch"></div><div class="ch"></div><div class="ch"></div><div class="ch"></div><div class="ch"></div><div class="cb"></div><div class="cb"></div><div></div>
                    <div></div><div></div><div class="cb"></div><div class="cb"></div><div class="ch"></div><div class="ch"></div><div class="ch"></div><div class="ch"></div><div class="ch"></div><div class="ch"></div><div class="ch"></div><div class="ch"></div><div class="cb"></div><div class="cb"></div><div></div><div></div>
                    <div></div><div></div><div class="cb"></div><div class="cb"></div><div class="ch"></div><div class="ch"></div><div class="ch"></div><div class="ch"></div><div class="ch"></div><div class="ch"></div><div class="ch"></div><div class="ch"></div><div class="cb"></div><div class="cb"></div><div></div><div></div>
                    <div></div><div></div><div></div><div class="cb"></div><div class="cb"></div><div class="ch"></div><div class="ch"></div><div class="ch"></div><div class="ch"></div><div class="ch"></div><div class="ch"></div><div class="cb"></div><div class="cb"></div><div></div><div></div><div></div>
                    <div></div><div></div><div></div><div class="cb"></div><div class="cb"></div><div class="cb"></div><div class="ch"></div><div class="ch"></div><div class="ch"></div><div class="ch"></div><div class="cb"></div><div class="cb"></div><div class="cb"></div><div></div><div></div><div></div>
                    <div></div><div></div><div class="cb"></div><div class="cb"></div><div></div><div></div><div class="cb"></div><div class="cb"></div><div class="cb"></div><div class="cb"></div><div></div><div></div><div class="cb"></div><div class="cb"></div><div></div><div></div>
                    <div></div><div></div><div class="cb"></div><div class="cb"></div><div></div><div></div><div class="cb"></div><div class="cb"></div><div class="cb"></div><div class="cb"></div><div></div><div></div><div class="cb"></div><div class="cb"></div><div></div><div></div>
                </div>

                <div class="btn-group" id="grupo-botones">
                    <button class="btn-retro" id="btn-yes" onclick="presionoSi()">YES</button>
                    <button class="btn-retro" id="btn-no" onmouseover="esquivarNo()" onclick="esquivarNo()">NO</button>
                </div>
            </div>
        </div>
    </div>

    <!-- PASO 3: CARTA, CONTADOR Y SPOTIFY -->
    <div class="paso-container" id="paso-carta">
        <div class="card-custom">
            <h2>1 MES CONTIGO ♡</h2>

            <!-- CONTADOR DE TIEMPO JUNTAS -->
            <div class="contador-box">
                <div class="contador-item"><span class="contador-num" id="cnt-dias">0</span>días</div>
                <div class="contador-item"><span class="contador-num" id="cnt-horas">0</span>horas</div>
                <div class="contador-item"><span class="contador-num" id="cnt-min">0</span>min</div>
                <div class="contador-item"><span class="contador-num" id="cnt-seg">0</span>seg</div>
            </div>

            <div class="carta-box" id="texto-carta"></div>
            
            <div class="spotify-container">
                <iframe style="border-radius:12px" src="https://open.spotify.com/embed/track/44AyOl4qVkzS48vBsbNXaC?utm_source=generator&theme=0" width="100%" height="80" frameBorder="0" allowfullscreen="" allow="autoplay; clipboard-write; encrypted-media; fullscreen; picture-in-picture" loading="lazy"></iframe>
            </div>

            <button class="btn-final" onclick="irAOrbe()">Siguiente ✨</button>
        </div>
    </div>

    <!-- PASO 4: INDEPENDIENTE - BOLA DE CRISTAL / ORBE ESTELAR -->
    <div class="paso-container" id="paso-orbe">
        <div class="card-custom">
            <h2>NUESTRO FUTURO JUNTAS</h2>
            <p style="font-size:0.85rem; color:#fce4ec; margin-top:4px;">Toca el orbe mágico para descubrir nuestras promesas...</p>

            <div class="orbe-cristal" onclick="revelarPromesaFutura()"></div>
            <div class="orbe-texto" id="texto-orbe">Haz clic en el orbe para consultar las estrellas... ✨</div>

            <button class="btn-final" onclick="irASilueta()">Continuar ♡</button>
        </div>
    </div>

    <!-- PASO 5: INDEPENDIENTE - SILUETA DEL ABRAZO DETALLADA -->
    <div class="paso-container" id="paso-silueta">
        <div class="card-custom">
            <h2>♡</h2>
            <p style="font-size:0.85rem; color:#fce4ec;">Para cuando nos tengamos cerca...</p>

            <svg class="silueta-svg" viewBox="0 0 240 260" fill="none" xmlns="http://www.w3.org/2000/svg">
                <!-- CHICA IZQUIERDA (Pelo largo suelto) -->
                <path d="M 45 45 C 30 55 35 85 45 105 C 38 120 32 145 35 175 C 38 200 48 225 55 245 L 85 245 C 80 220 78 185 75 160 C 82 155 88 145 92 135" stroke="#ff4d8d" stroke-width="2.8" stroke-linecap="round" fill="rgba(255, 77, 141, 0.12)"/>
                <!-- Cabello largo cayendo chica izquierda -->
                <path d="M 52 35 C 35 40 22 65 25 100 C 28 130 35 155 30 185" stroke="#ff8da1" stroke-width="2.2" stroke-linecap="round"/>
                
                <!-- CHICA DERECHA (Pelo recogido / trenza) -->
                <path d="M 195 45 C 210 55 205 85 195 105 C 202 120 208 145 205 175 C 202 200 192 225 185 245 L 155 245 C 160 220 162 185 165 160 C 158 155 152 145 148 135" stroke="#ff4d8d" stroke-width="2.8" stroke-linecap="round" fill="rgba(255, 77, 141, 0.12)"/>
                <!-- Trenza/peinado chica derecha -->
                <path d="M 175 28 C 188 30 198 42 192 58 C 188 70 195 82 190 95" stroke="#ff8da1" stroke-width="2.2" stroke-linecap="round"/>

                <!-- BRAZOS ABRAZANDO Y ENLAZADOS -->
                <!-- Brazo chica izquierda rodeando el cuello/espalda -->
                <path d="M 68 110 C 95 95 135 98 162 108 C 168 110 175 120 165 125 C 150 130 120 120 90 128" stroke="#ffb6c1" stroke-width="3" stroke-linecap="round"/>
                <!-- Brazo chica derecha rodeando la cintura/espalda -->
                <path d="M 172 115 C 145 125 105 122 78 112 C 72 110 65 100 75 95 C 90 90 120 100 150 92" stroke="#ffb6c1" stroke-width="3" stroke-linecap="round"/>

                <!-- ROSTROS Y CABEZAS REPOSANDO -->
                <path d="M 75 48 C 85 38 105 38 115 52 C 120 62 118 78 108 85 C 95 90 80 82 75 70 Z" stroke="#ff4d8d" stroke-width="2.2" fill="rgba(255, 182, 193, 0.2)"/>
                <path d="M 165 48 C 155 38 135 38 125 52 C 120 62 122 78 132 85 C 145 90 160 82 165 70 Z" stroke="#ff4d8d" stroke-width="2.2" fill="rgba(255, 182, 193, 0.2)"/>

                <!-- CORAZÓN RESPLANDECIENTE EN EL CENTRO DEL ABRAZO -->
                <path d="M 120 100 C 114 90 102 93 102 103 C 102 115 120 126 120 126 C 120 126 138 115 138 103 C 138 93 126 90 120 100 Z" fill="#ff1493" filter="drop-shadow(0 0 8px #ff4d8d)"/>
            </svg>

            <div class="texto-te-amo">TE AMO ♡</div>

            <button class="btn-final" onclick="irAFinal()">Ver mis flores 🌸</button>
        </div>
    </div>

    <!-- PASO 6: INDEPENDIENTE - FINAL CON FLORES ANIMADAS -->
    <div class="paso-container" id="paso-final">
        <div class="card-custom">
            <h2>NUESTRO PRIMER CAPÍTULO</h2>
            <p style="font-size:0.85rem; color:#fce4ec; margin-bottom:10px;">Flores eternas para mi niña hermosa: Gerbera, Tulipán y Lirio. ♡</p>
            
            <canvas id="flores-canvas"></canvas>

            <button class="btn-explorar" style="margin-bottom: 0;" onclick="reiniciarExperiencia()">Volver a empezar ✨</button>
        </div>
    </div>

    <script>
        const canvas = document.getElementById('universo');
        const ctx = canvas.getContext('2d');

        let width = canvas.width = window.innerWidth;
        let height = canvas.height = window.innerHeight;

        window.addEventListener('resize', () => {
            width = canvas.width = window.innerWidth;
            height = canvas.height = window.innerHeight;
            crearParticulas();
        });

        const totalEstrellas = 260;
        const estrellas = [];
        let velocidadAdentramiento = 2.2;
        let modoCorazon = false;

        const planetas = [
            { name: 'Saturno', x: -0.3, y: -0.2, z: 800, r: 42, color: '#ffb3ba', ring: true, ringColor: '#ff6781' },
            { name: 'Neptuno', x: 0.35, y: 0.25, z: 1400, r: 35, color: '#88d8b0', ring: false },
            { name: 'Rosado', x: -0.25, y: 0.3, z: 2000, r: 50, color: '#ff80bf', ring: true, ringColor: '#ffe6f2' }
        ];

        class Estrella {
            constructor(i) {
                this.i = i;
                this.reset();
            }

            reset() {
                this.x = (Math.random() - 0.5) * width * 1.8;
                this.y = (Math.random() - 0.5) * height * 1.8;
                this.z = Math.random() * width;
                this.size = Math.random() * 2 + 1;
                this.color = ['#ffffff', '#ffb6c1', '#ffc0cb', '#ff69b4', '#e6c2d4', '#85e3ff'][Math.floor(Math.random() * 6)];
                
                const t = (this.i / totalEstrellas) * Math.PI * 2;
                const scale = Math.min(width, height) / (width < 600 ? 48 : 36);
                const hx = 16 * Math.pow(Math.sin(t), 3);
                const hy = -(13 * Math.cos(t) - 5 * Math.cos(2*t) - 2 * Math.cos(3*t) - Math.cos(4*t));
                
                // CORAZÓN BAJADO PARA NO TAPAR LOS PLANETAS Y CONSTELACIONES
                this.targetX = width / 2 + hx * scale;
                this.targetY = (width < 600 ? height * 0.68 : height * 0.62) + hy * scale;
                this.posX = this.x;
                this.posY = this.y;
            }

            update() {
                if (!modoCorazon) {
                    this.z -= velocidadAdentramiento;
                    if (this.z <= 0) {
                        this.reset();
                        this.z = width;
                    }
                } else {
                    this.posX += (this.targetX - this.posX) * 0.04;
                    this.posY += (this.targetY - this.posY) * 0.04;
                }
            }

            draw() {
                ctx.save();
                if (!modoCorazon) {
                    const k = 255 / Math.max(1, this.z);
                    const px = this.x * k + width / 2;
                    const py = this.y * k + height / 2;

                    if (px >= 0 && px < width && py >= 0 && py < height) {
                        const size = Math.max(0.1, (1 - this.z / width) * 3 * this.size);
                        ctx.fillStyle = this.color;
                        ctx.shadowBlur = 8;
                        ctx.shadowColor = this.color;
                        ctx.beginPath();
                        ctx.arc(px, py, size, 0, Math.PI * 2);
                        ctx.fill();
                        this.posX = px;
                        this.posY = py;
                    }
                } else {
                    const fontSize = width < 600 ? '10px' : '12px';
                    ctx.font = `bold ${fontSize} Georgia`;
                    ctx.fillStyle = this.color;
                    ctx.shadowBlur = 12;
                    ctx.shadowColor = '#ff69b4';
                    ctx.fillText('i love you', this.posX, this.posY);
                }
                ctx.restore();
            }
        }

        function crearParticulas() {
            estrellas.length = 0;
            for (let i = 0; i < totalEstrellas; i++) {
                estrellas.push(new Estrella(i));
            }
        }
        crearParticulas();

        function dibujarPlanetas() {
            planetas.forEach(p => {
                if (!modoCorazon) {
                    p.z -= velocidadAdentramiento * 0.8;
                    if (p.z <= 0) p.z = 2200;
                }

                const k = 255 / Math.max(1, p.z);
                const px = p.x * width * k + width / 2;
                const py = p.y * height * k + height / 2;
                const radius = Math.max(2, p.r * k * 0.8);

                if (px > -100 && px < width + 100 && py > -100 && py < height + 100) {
                    ctx.save();
                    ctx.globalAlpha = modoCorazon ? 0.85 : Math.min(1, (2200 - p.z) / 500);

                    if (p.ring) {
                        ctx.strokeStyle = p.ringColor;
                        ctx.lineWidth = radius * 0.3;
                        ctx.beginPath();
                        ctx.ellipse(px, py, radius * 1.8, radius * 0.5, Math.PI / 6, 0, Math.PI * 2);
                        ctx.stroke();
                    }

                    const grad = ctx.createRadialGradient(px - radius * 0.3, py - radius * 0.3, radius * 0.1, px, py, radius);
                    grad.addColorStop(0, '#ffffff');
                    grad.addColorStop(0.5, p.color);
                    grad.addColorStop(1, '#000000');

                    ctx.fillStyle = grad;
                    ctx.beginPath();
                    ctx.arc(px, py, radius, 0, Math.PI * 2);
                    ctx.fill();

                    ctx.restore();
                }
            });
        }

        // --- CONSTELACIÓN LEO + CAPRICORNIO + HILO ROJO ---
        let anguloOrbita = 0;
        let pulsoLuz = 0;

        function dibujarConstelacionesYHilo() {
            if (!modoCorazon) return;

            anguloOrbita += 0.03;
            pulsoLuz += 0.02;

            const x1 = width * (width < 600 ? 0.15 : 0.2);
            const y1 = height * (width < 600 ? 0.18 : 0.22);
            const x2 = width * (width < 600 ? 0.85 : 0.8);
            const y2 = height * (width < 600 ? 0.18 : 0.22);
            const corazonY = (width < 600 ? height * 0.68 : height * 0.62);

            ctx.save();

            ctx.strokeStyle = 'rgba(255, 182, 193, 0.45)';
            ctx.lineWidth = 1;

            // Constelación Leo (21 de Agosto)
            const leoPuntos = [
                {x: x1 - 30, y: y1 - 25}, {x: x1 - 10, y: y1 - 35},
                {x: x1 + 10, y: y1 - 20}, {x: x1, y: y1},
                {x: x1 - 25, y: y1 + 15}, {x: x1 - 45, y: y1 + 5}
            ];
            ctx.beginPath();
            leoPuntos.forEach((p, idx) => {
                if (idx === 0) ctx.moveTo(p.x, p.y);
                else ctx.lineTo(p.x, p.y);
            });
            ctx.closePath();
            ctx.stroke();

            leoPuntos.forEach(p => {
                ctx.fillStyle = '#ffd700';
                ctx.beginPath();
                ctx.arc(p.x, p.y, 2, 0, Math.PI * 2);
                ctx.fill();
            });

            // Constelación Capricornio (30 de Diciembre)
            const capPuntos = [
                {x: x2 - 20, y: y2 - 30}, {x: x2 + 15, y: y2 - 25},
                {x: x2 + 35, y: y2 - 5}, {x: x2 + 20, y: y2 + 20},
                {x: x2 - 10, y: y2 + 10}, {x: x2, y: y2}
            ];
            ctx.beginPath();
            capPuntos.forEach((p, idx) => {
                if (idx === 0) ctx.moveTo(p.x, p.y);
                else ctx.lineTo(p.x, p.y);
            });
            ctx.closePath();
            ctx.stroke();

            capPuntos.forEach(p => {
                ctx.fillStyle = '#85e3ff';
                ctx.beginPath();
                ctx.arc(p.x, p.y, 2, 0, Math.PI * 2);
                ctx.fill();
            });

            // Hilo Rojo
            const gradHilo = ctx.createLinearGradient(x1, y1, x2, y2);
            gradHilo.addColorStop(0, '#ff4d8d');
            gradHilo.addColorStop(0.5, '#ffffff');
            gradHilo.addColorStop(1, '#ff4d8d');

            ctx.strokeStyle = gradHilo;
            ctx.lineWidth = 2.5;
            ctx.shadowBlur = 15 + Math.sin(pulsoLuz) * 5;
            ctx.shadowColor = '#ff1493';
            ctx.setLineDash([10, 8]);
            ctx.lineDashOffset = -anguloOrbita * 15;

            ctx.beginPath();
            ctx.moveTo(x1, y1);
            ctx.quadraticCurveTo(width / 2, corazonY - 80, x2, y2);
            ctx.stroke();

            ctx.setLineDash([]);
            const tLuz = (Math.sin(pulsoLuz * 1.5) + 1) / 2;
            const lx = (1 - tLuz) * (1 - tLuz) * x1 + 2 * (1 - tLuz) * tLuz * (width / 2) + tLuz * tLuz * x2;
            const ly = (1 - tLuz) * (1 - tLuz) * y1 + 2 * (1 - tLuz) * tLuz * (corazonY - 80) + tLuz * tLuz * y2;

            ctx.fillStyle = '#ffffff';
            ctx.shadowBlur = 12;
            ctx.shadowColor = '#ffe6f2';
            ctx.beginPath();
            ctx.arc(lx, ly, 4, 0, Math.PI * 2);
            ctx.fill();

            function dibujarPuntoConEstrellas(x, y, texto, signo) {
                ctx.fillStyle = '#ffffff';
                ctx.shadowBlur = 20;
                ctx.shadowColor = '#ff8da1';
                ctx.beginPath();
                ctx.arc(x, y, 7, 0, Math.PI * 2);
                ctx.fill();

                const numEstrellas = 5;
                for (let i = 0; i < numEstrellas; i++) {
                    const a = anguloOrbita + (i * Math.PI * 2 / numEstrellas);
                    const rx = x + Math.cos(a) * 22;
                    const ry = y + Math.sin(a) * 12;

                    ctx.fillStyle = i % 2 === 0 ? '#ffd700' : '#ffffff';
                    ctx.font = '9px Arial';
                    ctx.shadowBlur = 8;
                    ctx.shadowColor = '#ffd700';
                    ctx.fillText('★', rx, ry);
                }

                ctx.font = '600 12px Cinzel, serif';
                ctx.fillStyle = '#ffe0e9';
                ctx.shadowBlur = 12;
                ctx.shadowColor = '#ff1493';
                ctx.textAlign = 'center';
                ctx.fillText(texto, x, y - 22);

                ctx.font = '10px Montserrat';
                ctx.fillStyle = '#ffb6c1';
                ctx.fillText(signo, x, y + 25);
            }

            dibujarPuntoConEstrellas(x1, y1, 'TÚ ♡', '21 Ago (Leo)');
            dibujarPuntoConEstrellas(x2, y2, 'YO ♡', '30 Dic (Cap)');

            ctx.restore();
        }

        // --- ESTRELLAS FUGACES INTERACTIVAS ---
        const estrellasFugaces = [];
        const mensajesSecretos = [
            "Cada estrella me recuerda que aunque estemos lejos, vemos el mismo cielo. ♡",
            "Mi momento favorito del día siempre es cuando me llega una notificación tuya. ✨",
            "Promesa: En cuanto te vea te voy a dar el abrazo más fuerte del mundo. 🐻",
            "Eres el pensamiento más bonito y constante que tengo en mi día. 💖",
            "Te amo con todo mi corazón, hoy, mañana y siempre. 🌹"
        ];

        function crearEstrellaFugaz() {
            if (modoCorazon && Math.random() < 0.03 && estrellasFugaces.length < 3) {
                estrellasFugaces.push({
                    x: Math.random() * width * 0.8,
                    y: Math.random() * height * 0.3,
                    vx: Math.random() * 4 + 4,
                    vy: Math.random() * 2 + 2,
                    largo: Math.random() * 40 + 30,
                    size: 5,
                    mensaje: mensajesSecretos[Math.floor(Math.random() * mensajesSecretos.length)]
                });
            }
        }

        function dibujarEstrellasFugaces() {
            estrellasFugaces.forEach((ef, idx) => {
                ef.x += ef.vx;
                ef.y += ef.vy;

                ctx.save();
                const grad = ctx.createLinearGradient(ef.x, ef.y, ef.x - ef.largo, ef.y - ef.largo * 0.5);
                grad.addColorStop(0, '#ffffff');
                grad.addColorStop(1, 'rgba(255, 105, 180, 0)');

                ctx.strokeStyle = grad;
                ctx.lineWidth = 3;
                ctx.beginPath();
                ctx.moveTo(ef.x, ef.y);
                ctx.lineTo(ef.x - ef.largo, ef.y - ef.largo * 0.5);
                ctx.stroke();

                ctx.fillStyle = '#ffffff';
                ctx.shadowBlur = 10;
                ctx.shadowColor = '#ff69b4';
                ctx.beginPath();
                ctx.arc(ef.x, ef.y, ef.size, 0, Math.PI * 2);
                ctx.fill();
                ctx.restore();

                if (ef.x > width + 50 || ef.y > height + 50) {
                    estrellasFugaces.splice(idx, 1);
                }
            });
        }

        window.addEventListener('pointerdown', (e) => {
            estrellasFugaces.forEach((ef, idx) => {
                const dist = Math.hypot(e.clientX - ef.x, e.clientY - ef.y);
                if (dist < 40) {
                    abrirPopupSecreto(ef.mensaje);
                    estrellasFugaces.splice(idx, 1);
                }
            });
        });

        function abrirPopupSecreto(msg) {
            document.getElementById('texto-secreto').innerText = msg;
            document.getElementById('popup-secreto').classList.add('visible');
        }

        function cerrarPopupSecreto() {
            document.getElementById('popup-secreto').classList.remove('visible');
        }

        // --- BOLA DE CRISTAL / ORBE ESTELAR DE PROMESAS FUTURAS ---
        const promesasFuturas = [
            "✨ Promesa 1: Un abrazo ke parezca q no terminara nunca.",
            "🌙 Promesa 2: Una caminata nocturna tomadas de la mano sin importar la hora.",
            "🍕 Promesa 3: Una maratón de nuestras películas favoritas comiendo pizza juntas.",
            "☕ Promesa 4: Prepararte mi platillo estrella, un chocomilk por que es lo unico q se hacer.",
            "📸 Promesa 5: Llenar un álbum completo con nuestras fotos juntas en persona.",
            "🌹 Promesa 6: Regalarte flores de verdad y ver tus ojos brillar."
        ];
        let indexPromesa = 0;

        function revelarPromesaFutura() {
            const textoOrbe = document.getElementById('texto-orbe');
            textoOrbe.style.opacity = '0';
            setTimeout(() => {
                textoOrbe.innerText = promesasFuturas[indexPromesa];
                textoOrbe.style.opacity = '1';
                indexPromesa = (indexPromesa + 1) % promesasFuturas.length;
            }, 200);
        }

        function render() {
            ctx.fillStyle = 'rgba(3, 1, 6, 0.25)';
            ctx.fillRect(0, 0, width, height);

            dibujarPlanetas();
            dibujarConstelacionesYHilo();

            crearEstrellaFugaz();
            dibujarEstrellasFugaces();

            estrellas.forEach(e => {
                e.update();
                e.draw();
            });

            requestAnimationFrame(render);
        }
        render();

        function adentrarseEnUniverso() {
            document.getElementById('pantalla-inicio').classList.add('hidden');
            
            let aceleracion = setInterval(() => {
                velocidadAdentramiento += 0.8;
            }, 50);

            setTimeout(() => {
                clearInterval(aceleracion);
                modoCorazon = true;

                // El corazón aparece después de la aceleración y permanece 5 segundos.
                setTimeout(() => {
                    modoCorazon = false;
                    velocidadAdentramiento = 2.2;

                    // Después del corazón comienzan las ventanas de la experiencia.
                    setTimeout(() => {
                        document.getElementById('paso-pregunta').classList.add('visible');
                    }, 600);
                }, 5000);
            }, 3200);
        }

        let escalaYes = 1;
        const btnYes = document.getElementById('btn-yes');
        const btnNo = document.getElementById('btn-no');

        function esquivarNo() {
            const grupo = document.getElementById('grupo-botones');
            const rect = grupo.getBoundingClientRect();

            const xMax = (rect.width / 2) - 30;
            const yMax = 25;

            const randomX = (Math.random() - 0.5) * xMax * 2;
            const randomY = (Math.random() - 0.5) * yMax * 2;

            btnNo.style.position = 'relative';
            btnNo.style.left = `${randomX}px`;
            btnNo.style.top = `${randomY}px`;

            escalaYes += 0.15;
            btnYes.style.transform = `scale(${escalaYes})`;

            if (escalaYes > 2.8) {
                btnYes.style.position = 'fixed';
                btnYes.style.top = '0';
                btnYes.style.left = '0';
                btnYes.style.width = '100vw';
                btnYes.style.height = '100vh';
                btnYes.style.zIndex = '999';
                btnYes.style.borderRadius = '0';
                btnYes.style.fontSize = '1.8rem';
                btnYes.style.display = 'flex';
                btnYes.style.alignItems = 'center';
                btnYes.style.justifyContent = 'center';
            }
        }

        function presionoSi() {
            document.getElementById('paso-pregunta').classList.remove('visible');
            lanzarLluviaCorazones();
            setTimeout(() => {
                document.getElementById('paso-carta').classList.add('visible');
                escribirCarta();
            }, 500);
        }

        const textoCarta = 
            "Hola corazón, ¿el tiempo pasa rápido, no? Hoy cumplimos un mes de noviecitas y todavía me cuesta creer que ya haya pasado un mes desde que empezamos esto. Al principio yo pensaba que enamorarse era cosa de personas tontas y que era algo absurdo eso de entregarle tanto de ti a alguien y amarla incondicionalmente, y ahora puedo considerarme una persona realmente hipócrita porque terminé enamorándome de ti de una manera que nunca imaginé. Ahora mismo eres uno de mis pensamientos más bonitos y constantes, y amo poder amarte de esta manera.\n\n" +
            "Quiero permanecer a tu lado por mucho más que unos cuantos meses, quiero que este sea solamente el primero de muchísimos. Eres una personita demasiado especial para mí y siento que nuestras personalidades se complementan de una manera tan bonita. Cada día contigo me haces sentir más segura, más querida y más tranquila. Nunca creí sentirme así de bien con alguien, ni mucho menos sentir tanta confianza como la que poco a poco he aprendido a tener contigo.\n\n" +
            "Contigo también aprendí a ser más cariñosa y romántica. Antes me daba mucha pena decir cosas tan cursis, pero contigo puedo decirte mi niña linda, my pookie, mi hermosa nobiesita y todas esas cosas que salen de mí cuando estoy pensando en ti. Amo poder ser así contigo, poder decirte todo lo que siento aunque a veces no encuentre las palabras suficientes para explicarte cuánto te amo.\n\n" +
            "También amo que, aunque nuestra relación sea a distancia, puedas hacerme sentir tan cerca de ti. Obviamente quisiera poder estar a tu lado, abrazarte, pasar tiempo contigo y simplemente tenerte cerquita, pero aun con todos esos kilómetros entre nosotras, logras hacerme sentir querida y acompañada. Me haces sentir que la distancia no cambia lo que siento por ti.\n\n" +
            "El 12 de septiembre de 2026 te propuse ser mi novia y desde entonces comenzamos algo que quiero cuidar con todo mi corazón. Este primer mes quiero que sea solamente el comienzo de todos los meses que todavía nos quedan por vivir juntas. Quiero seguir compartiendo contigo nuestras conversaciones, nuestras risas, nuestros momentos bonitos y también esos días en los que alguna de las dos no se encuentre del todo bien.\n\n" +
            "Este año me regaló a una de las personas más bonitas que podía haber conocido, pero no quiero que seas solamente parte de este año. Quiero que sigas formando parte de mi vida durante muchísimo tiempo. Eres una persona que me hace bien, que me hace sentir afortunada y que quiero conservar cerca de mi corazón.\n\n" +
            "Con este primer mes quiero prometerte algo: quiero estar contigo en las buenas y en las malas. Quiero seguir aprendiendo a quererte, entenderte y demostrarte todo lo que siento por ti. Si algún día algo no está bien, quiero que puedas decírmelo, porque quiero que siempre podamos hablar las cosas y entendernos. Me gusta que cuando tenemos algún momento difícil, al hablarlo podemos volver a reírnos juntas y sentir que todo vuelve a estar bien, como si por un momento solo existiéramos tú y yo.\n\n" +
            "Quiero terminar este año contigo porque lo estoy comenzando con la persona que amo, pero también quiero que seas parte de muchos años más. Quiero seguir celebrando nuestros meses, seguir diciéndote cuánto te amo y seguir construyendo esto poquito a poquito, sin importar la distancia.\n\n" +
            "Te amo muchísimo, corazón. A veces siento que te amo tanto que me dan ganas de llorar, porque nunca pensé que alguien pudiera llegar a significar tanto para mí. Gracias por este primer mes, por cada conversación, cada momento bonito, cada palabra y por dejarme formar parte de tu vida.\n\n" +
            "Nunca olvides que eres mi niña linda y la persona mas hermosa, increible, podria decir perfecta Pero la perfección no existe aunque tu no estas lejos de serlo y la persona que amo con todo mi corazón.";

        let indexCarta = 0;
        function escribirCarta() {
            if (indexCarta < textoCarta.length) {
                const char = textoCarta.charAt(indexCarta);
                document.getElementById('texto-carta').innerHTML += char === '\n' ? '<br>' : char;
                indexCarta++;
                setTimeout(escribirCarta, 16);
            }
        }

        // CONTROL DE PASOS INDEPENDIENTES
        function irAOrbe() {
            document.getElementById('paso-carta').classList.remove('visible');
            setTimeout(() => {
                document.getElementById('paso-orbe').classList.add('visible');
            }, 400);
        }

        function irASilueta() {
            document.getElementById('paso-orbe').classList.remove('visible');
            setTimeout(() => {
                document.getElementById('paso-silueta').classList.add('visible');
            }, 400);
        }

        function irAFinal() {
            document.getElementById('paso-silueta').classList.remove('visible');
            setTimeout(() => {
                document.getElementById('paso-final').classList.add('visible');
                iniciarAnimacionFlores();
            }, 400);
        }

        function reiniciarExperiencia() {
            location.reload();
        }

        // --- CONTADOR DE AMOR EN TIEMPO REAL ---
        const fechaInicio = new Date('2026-09-12T21:00:00');

        function actualizarContador() {
            const ahora = new Date();
            const diferencia = ahora - fechaInicio;

            if (diferencia > 0) {
                const dias = Math.floor(diferencia / (1000 * 60 * 60 * 24));
                const horas = Math.floor((diferencia / (1000 * 60 * 60)) % 24);
                const minutos = Math.floor((diferencia / 1000 / 60) % 60);
                const segundos = Math.floor((diferencia / 1000) % 60);

                document.getElementById('cnt-dias').innerText = dias;
                document.getElementById('cnt-horas').innerText = horas;
                document.getElementById('cnt-min').innerText = minutos;
                document.getElementById('cnt-seg').innerText = segundos;
            }
        }
        setInterval(actualizarContador, 1000);
        actualizarContador();

        // --- EFECTO DE LLOVER CORAZONES Y CHISPAS AL TOCAR / HACER CLIC ---
        function lanzarLluviaCorazones() {
            const cCanvas = document.getElementById('corazones-canvas');
            const cCtx = cCanvas.getContext('2d');
            cCanvas.width = window.innerWidth;
            cCanvas.height = window.innerHeight;

            const listaCorazones = [];
            for (let i = 0; i < 90; i++) {
                listaCorazones.push({
                    x: Math.random() * cCanvas.width,
                    y: Math.random() * cCanvas.height - cCanvas.height,
                    size: Math.random() * 20 + 12,
                    speedY: Math.random() * 3 + 2,
                    speedX: (Math.random() - 0.5) * 2,
                    color: ['#ff4d8d', '#ff8da1', '#ffb6c1', '#ffffff'][Math.floor(Math.random() * 4)]
                });
            }

            function animarCorazones() {
                cCtx.clearRect(0, 0, cCanvas.width, cCanvas.height);

                particulasToque.forEach((p, idx) => {
                    p.x += p.vx;
                    p.y += p.vy;
                    p.alpha -= 0.02;
                    if (p.alpha <= 0) particulasToque.splice(idx, 1);

                    cCtx.save();
                    cCtx.globalAlpha = Math.max(0, p.alpha);
                    cCtx.fillStyle = p.color;
                    cCtx.font = `${p.size}px Arial`;
                    cCtx.fillText(p.simbolo, p.x, p.y);
                    cCtx.restore();
                });

                listaCorazones.forEach(c => {
                    c.y += c.speedY;
                    c.x += c.speedX;
                    if (c.y > cCanvas.height) c.y = -20;

                    cCtx.save();
                    cCtx.fillStyle = c.color;
                    cCtx.font = `${c.size}px Arial`;
                    cCtx.fillText('♥', c.x, c.y);
                    cCtx.restore();
                });
                requestAnimationFrame(animarCorazones);
            }
            animarCorazones();
        }

        const particulasToque = [];
        window.addEventListener('pointerdown', (e) => {
            const cCanvas = document.getElementById('corazones-canvas');
            if (!cCanvas.width) {
                cCanvas.width = window.innerWidth;
                cCanvas.height = window.innerHeight;
            }
            for (let i = 0; i < 12; i++) {
                particulasToque.push({
                    x: e.clientX,
                    y: e.clientY,
                    vx: (Math.random() - 0.5) * 6,
                    vy: (Math.random() - 0.5) * 6 - 2,
                    alpha: 1,
                    size: Math.random() * 18 + 10,
                    simbolo: ['♥', '✨', '🌸', '★'][Math.floor(Math.random() * 4)],
                    color: ['#ff4d8d', '#ffb6c1', '#ffe6f2', '#ffd700'][Math.floor(Math.random() * 4)]
                });
            }
        });

        // --- ANIMACIÓN BOTÁNICA DE FLORES ---
        function iniciarAnimacionFlores() {
            const fCanvas = document.getElementById('flores-canvas');
            const fCtx = fCanvas.getContext('2d');

            fCanvas.width = fCanvas.offsetWidth;
            fCanvas.height = fCanvas.offsetHeight;

            let progresoTallo = 0;
            let progresoPetalos = 0;

            function dibujarPetalo(ctx, x, y, largo, ancho, angulo, colorBase, colorPunta, progreso) {
                ctx.save();
                ctx.translate(x, y);
                ctx.rotate(angulo);

                const largoActual = largo * progreso;
                const anchoActual = ancho * progreso;

                const gradiente = ctx.createLinearGradient(0, 0, 0, -largoActual);
                gradiente.addColorStop(0, colorBase);
                gradiente.addColorStop(1, colorPunta);

                ctx.fillStyle = gradiente;
                ctx.beginPath();
                ctx.moveTo(0, 0);
                ctx.bezierCurveTo(-anchoActual / 2, -largoActual * 0.4, -anchoActual / 2, -largoActual * 0.8, 0, -largoActual);
                ctx.bezierCurveTo(anchoActual / 2, -largoActual * 0.8, anchoActual / 2, -largoActual * 0.4, 0, 0);
                ctx.fill();

                ctx.strokeStyle = 'rgba(255, 255, 255, 0.2)';
                ctx.lineWidth = 1;
                ctx.beginPath();
                ctx.moveTo(0, 0);
                ctx.lineTo(0, -largoActual * 0.9);
                ctx.stroke();

                ctx.restore();
            }

            function renderFlores() {
                fCtx.clearRect(0, 0, fCanvas.width, fCanvas.height);

                const baseY = fCanvas.height - 10;
                const centroX = fCanvas.width / 2;

                if (progresoTallo < 1) progresoTallo += 0.015;

                fCtx.strokeStyle = '#2d5a27';
                fCtx.lineWidth = 4;
                fCtx.lineCap = 'round';

                // Tallo Gerbera
                fCtx.beginPath();
                fCtx.moveTo(centroX - 60, baseY);
                fCtx.quadraticCurveTo(centroX - 80, baseY - 50, centroX - 90, baseY - (100 * progresoTallo));
                fCtx.stroke();

                // Tallo Tulipán
                fCtx.beginPath();
                fCtx.moveTo(centroX, baseY);
                fCtx.lineTo(centroX, baseY - (115 * progresoTallo));
                fCtx.stroke();

                // Tallo Lirio
                fCtx.beginPath();
                fCtx.moveTo(centroX + 60, baseY);
                fCtx.quadraticCurveTo(centroX + 80, baseY - 50, centroX + 90, baseY - (100 * progresoTallo));
                fCtx.stroke();

                if (progresoTallo >= 0.8) {
                    if (progresoPetalos < 1) progresoPetalos += 0.012;

                    // GERBERA
                    const gx = centroX - 90;
                    const gy = baseY - 100;
                    const totalPetalosGerbera = 24;

                    for (let i = 0; i < totalPetalosGerbera; i++) {
                        const angulo = (i * (Math.PI * 2 / totalPetalosGerbera));
                        const retraso = Math.max(0, Math.min(1, (progresoPetalos * 1.3) - (i * 0.015)));
                        dibujarPetalo(fCtx, gx, gy, 38, 9, angulo, '#ff1493', '#ffb6c1', retraso);
                    }
                    fCtx.fillStyle = '#4a2511';
                    fCtx.beginPath();
                    fCtx.arc(gx, gy, 8 * progresoPetalos, 0, Math.PI * 2);
                    fCtx.fill();

                    // TULIPÁN
                    const tx = centroX;
                    const ty = baseY - 115;
                    const angulosTulipan = [-0.3, 0, 0.3, -0.15, 0.15];
                    const coloresTulipan = [
                        ['#e63946', '#ff758f'],
                        ['#ff4d6d', '#ff8fa3'],
                        ['#c9184a', '#ff758f']
                    ];

                    angulosTulipan.forEach((ang, idx) => {
                        const retraso = Math.max(0, Math.min(1, (progresoPetalos * 1.2) - (idx * 0.1)));
                        const col = coloresTulipan[idx % 3];
                        dibujarPetalo(fCtx, tx, ty, 42, 22, ang, col[0], col[1], retraso);
                    });

                    // LIRIO
                    const lx = centroX + 90;
                    const ly = baseY - 100;
                    const angulosLirio = [0, 1.04, 2.09, 3.14, 4.18, 5.23];

                    angulosLirio.forEach((ang, idx) => {
                        const retraso = Math.max(0, Math.min(1, (progresoPetalos * 1.2) - (idx * 0.08)));
                        dibujarPetalo(fCtx, lx, ly, 45, 14, ang, '#ffffff', '#ff9ebb', retraso);
                    });

                    if (progresoPetalos > 0.6) {
                        fCtx.strokeStyle = '#ffd700';
                        fCtx.lineWidth = 1.5;
                        for (let a = 0; a < 5; a++) {
                            const stAng = (a * 1.2) - 1.2;
                            fCtx.beginPath();
                            fCtx.moveTo(lx, ly);
                            fCtx.lineTo(lx + Math.sin(stAng) * 15, ly - Math.cos(stAng) * 15);
                            fCtx.stroke();
                        }
                    }
                }

                if (progresoPetalos < 1) {
                    requestAnimationFrame(renderFlores);
                }
            }

            renderFlores();
        }
    </script>
</body>
</html>