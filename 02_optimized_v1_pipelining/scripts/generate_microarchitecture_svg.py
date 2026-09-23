"""
Generates an IEEE Publication-Quality Vector SVG Diagram of the
4-Stage Pipelined 2D Convolution Hardware Accelerator Microarchitecture.
"""

def generate_svg():
    width = 1600
    height = 980

    svg = []
    svg.append(f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {width} {height}" width="{width}" height="{height}" font-family="-apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, Helvetica, Arial, sans-serif">')

    # Definitions
    svg.append('''
    <defs>
        <marker id="arrow" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="6" markerHeight="6" orient="auto-start-reverse">
            <path d="M 0 1.5 L 9 5 L 0 8.5 z" fill="#334155" />
        </marker>
        <marker id="arrow-blue" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="6" markerHeight="6" orient="auto-start-reverse">
            <path d="M 0 1.5 L 9 5 L 0 8.5 z" fill="#1e40af" />
        </marker>
        <marker id="arrow-green" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="6" markerHeight="6" orient="auto-start-reverse">
            <path d="M 0 1.5 L 9 5 L 0 8.5 z" fill="#15803d" />
        </marker>
        <marker id="arrow-orange" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="6" markerHeight="6" orient="auto-start-reverse">
            <path d="M 0 1.5 L 9 5 L 0 8.5 z" fill="#c2410c" />
        </marker>
        <marker id="arrow-purple" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="6" markerHeight="6" orient="auto-start-reverse">
            <path d="M 0 1.5 L 9 5 L 0 8.5 z" fill="#6b21a8" />
        </marker>
        <filter id="shadow" x="-5%" y="-5%" width="110%" height="115%" filterUnits="userSpaceOnUse">
            <feDropShadow dx="0" dy="2" stdDeviation="3" flood-opacity="0.06" flood-color="#000000" />
        </filter>
        <linearGradient id="header-grad" x1="0%" y1="0%" x2="100%" y2="0%">
            <stop offset="0%" stop-color="#0f172a" />
            <stop offset="100%" stop-color="#1e3a8a" />
        </linearGradient>
    </defs>
    ''')

    # Background
    svg.append(f'<rect width="{width}" height="{height}" fill="#f8fafc" />')

    # Top Header Banner
    svg.append(f'''
    <rect x="0" y="0" width="{width}" height="64" fill="url(#header-grad)" />
    <text x="30" y="36" fill="#ffffff" font-size="20" font-weight="700" letter-spacing="0.4">IEEE Standard Microarchitecture: 4-Stage Pipelined 2D Convolution Accelerator</text>
    <text x="30" y="54" fill="#93c5fd" font-size="11.5">Target FPGA: Intel Cyclone V (5CSXFC6D6F31C6) | 185.15 MHz Fmax | Clock Period: 10.0 ns | conv_optimized.v</text>
    <text x="{width - 30}" y="38" fill="#e2e8f0" font-size="12" font-weight="600" text-anchor="end">RTL &amp; Microarchitecture Specification</text>
    ''')

    # Stage Column Boundaries
    stages = [
        {"name": "STAGE 0: INPUTS & STORAGE", "sub": "Cycle 0: Addr Decode & Latch", "x": 25, "w": 235, "bg": "#f1f5f9", "accent": "#475569"},
        {"name": "STAGE 1: 16×16 MULTIPLIERS", "sub": "Cycle 1: 9 Parallel DSP Multipliers", "x": 275, "w": 285, "bg": "#eff6ff", "accent": "#1e40af"},
        {"name": "STAGE 2: ADDER TREE LEVEL 1", "sub": "Cycle 2: 4 Pairwise Sums + Delay Reg", "x": 575, "w": 285, "bg": "#f0fdf4", "accent": "#15803d"},
        {"name": "STAGE 3: ADDER TREE LEVEL 2", "sub": "Cycle 3: 2 Quad Sums + Delay Reg", "x": 875, "w": 285, "bg": "#fff7ed", "accent": "#c2410c"},
        {"name": "STAGE 4: ACCUMULATION & OUTPUT", "sub": "Cycle 4: Final Sum & Handshake", "x": 1175, "w": 400, "bg": "#faf5ff", "accent": "#6b21a8"}
    ]

    for st in stages:
        svg.append(f'''
        <rect x="{st['x']}" y="76" width="{st['w']}" height="825" rx="6" fill="{st['bg']}" stroke="#cbd5e1" stroke-width="1.2" stroke-dasharray="4 2" />
        <rect x="{st['x']}" y="76" width="{st['w']}" height="38" rx="6" fill="{st['accent']}" />
        <rect x="{st['x']}" y="106" width="{st['w']}" height="8" fill="{st['accent']}" />
        <text x="{st['x'] + st['w']/2}" y="93" fill="#ffffff" font-size="11" font-weight="700" text-anchor="middle">{st['name']}</text>
        <text x="{st['x'] + st['w']/2}" y="107" fill="#e2e8f0" font-size="9" text-anchor="middle">{st['sub']}</text>
        ''')

    # =========================================================================
    # 1. CONTROL PATH (Top Bar across Stages 0..4)
    # =========================================================================
    svg.append('''
    <!-- Control Path Container -->
    <rect x="35" y="125" width="1530" height="52" rx="5" fill="#ffffff" stroke="#cbd5e1" stroke-width="1" filter="url(#shadow)" />
    <text x="48" y="142" fill="#0f172a" font-size="10" font-weight="700">CONTROL PATH &amp; HANDSHAKE (4-Cycle Shift Register):</text>
    
    <!-- start port -->
    <rect x="48" y="147" width="55" height="22" rx="3" fill="#f1f5f9" stroke="#94a3b8" stroke-width="1" />
    <text x="75" y="162" fill="#0f172a" font-size="10" font-weight="700" text-anchor="middle">start</text>

    <!-- Wire start -> pipe[0] -->
    <line x1="103" y1="158" x2="385" y2="158" stroke="#1e40af" stroke-width="1.8" marker-end="url(#arrow-blue)" />

    <!-- FF 0: pipe[0] -->
    <rect x="385" y="144" width="65" height="26" rx="3" fill="#ffffff" stroke="#1e40af" stroke-width="1.5" />
    <text x="417" y="161" fill="#1e40af" font-size="9.5" font-weight="700" text-anchor="middle">pipe[0]</text>
    <polygon points="385,164 390,160 385,156" fill="#1e40af" />

    <!-- Wire pipe[0] -> pipe[1] -->
    <line x1="450" y1="158" x2="685" y2="158" stroke="#15803d" stroke-width="1.8" marker-end="url(#arrow-green)" />

    <!-- FF 1: pipe[1] -->
    <rect x="685" y="144" width="65" height="26" rx="3" fill="#ffffff" stroke="#15803d" stroke-width="1.5" />
    <text x="717" y="161" fill="#15803d" font-size="9.5" font-weight="700" text-anchor="middle">pipe[1]</text>
    <polygon points="685,164 690,160 685,156" fill="#15803d" />

    <!-- Wire pipe[1] -> pipe[2] -->
    <line x1="750" y1="158" x2="985" y2="158" stroke="#c2410c" stroke-width="1.8" marker-end="url(#arrow-orange)" />

    <!-- FF 2: pipe[2] -->
    <rect x="985" y="144" width="65" height="26" rx="3" fill="#ffffff" stroke="#c2410c" stroke-width="1.5" />
    <text x="1017" y="161" fill="#c2410c" font-size="9.5" font-weight="700" text-anchor="middle">pipe[2]</text>
    <polygon points="985,164 990,160 985,156" fill="#c2410c" />

    <!-- Wire pipe[2] -> pipe[3] -->
    <line x1="1050" y1="158" x2="1285" y2="158" stroke="#6b21a8" stroke-width="1.8" marker-end="url(#arrow-purple)" />

    <!-- FF 3: pipe[3] (done latch) -->
    <rect x="1285" y="144" width="65" height="26" rx="3" fill="#ffffff" stroke="#6b21a8" stroke-width="1.5" />
    <text x="1317" y="161" fill="#6b21a8" font-size="9.5" font-weight="700" text-anchor="middle">pipe[3]</text>
    <polygon points="1285,164 1290,160 1285,156" fill="#6b21a8" />

    <!-- Wire pipe[3] -> done port -->
    <line x1="1350" y1="158" x2="1455" y2="158" stroke="#6b21a8" stroke-width="2" marker-end="url(#arrow-purple)" />
    <rect x="1455" y="145" width="75" height="25" rx="3" fill="#1e40af" stroke="#0f172a" stroke-width="1.5" />
    <text x="1492" y="162" fill="#ffffff" font-size="10.5" font-weight="700" text-anchor="middle">done</text>
    ''')

    # =========================================================================
    # 2. STAGE 0: INPUT INTERFACE & STORAGE
    # =========================================================================
    svg.append('''
    <!-- Inputs port box -->
    <rect x="35" y="185" width="95" height="52" rx="4" fill="#ffffff" stroke="#cbd5e1" stroke-width="1.2" />
    <text x="43" y="200" fill="#0f172a" font-size="9.5" font-weight="700">data_in [15:0]</text>
    <text x="43" y="215" fill="#475569" font-size="8.5">addr [4:0]</text>
    <text x="43" y="229" fill="#475569" font-size="8.5">load_en, clk, rst</text>

    <!-- Address Decoder Box -->
    <rect x="150" y="185" width="100" height="52" rx="4" fill="#f8fafc" stroke="#94a3b8" stroke-width="1" />
    <text x="200" y="203" fill="#0f172a" font-size="9" font-weight="700" text-anchor="middle">Address Map</text>
    <text x="200" y="217" fill="#64748b" font-size="8" text-anchor="middle">0..8: Pixels (p_ij)</text>
    <text x="200" y="229" fill="#64748b" font-size="8" text-anchor="middle">9..17: Kernels (k_ij)</text>

    <line x1="130" y1="211" x2="150" y2="211" stroke="#334155" stroke-width="1.4" marker-end="url(#arrow)" />
    ''')

    # Row coordinates for 9 branches
    row_y = [272, 340, 408, 476, 544, 612, 680, 748, 816]
    labels = [
        ("p00", "k00", "m00_r"),
        ("p01", "k01", "m01_r"),
        ("p02", "k02", "m02_r"),
        ("p10", "k10", "m10_r"),
        ("p11", "k11", "m11_r"),
        ("p12", "k12", "m12_r"),
        ("p20", "k20", "m20_r"),
        ("p21", "k21", "m21_r"),
        ("p22", "k22", "m22_r")
    ]

    for i, (p, k, m) in enumerate(labels):
        y = row_y[i]
        svg.append(f'''
        <!-- Branch {i}: {p} & {k} stacked vertically -->
        <!-- Pixel Reg -->
        <rect x="38" y="{y-19}" width="105" height="18" rx="2" fill="#ffffff" stroke="#475569" stroke-width="1.1" />
        <polygon points="38,{y-8} 42,{y-10} 38,{y-12}" fill="#475569" />
        <text x="46" y="{y-6}" fill="#0f172a" font-size="9" font-weight="700">{p} [15:0]</text>
        <text x="138" y="{y-6}" fill="#94a3b8" font-size="7.5" text-anchor="end">P</text>

        <!-- Kernel Reg -->
        <rect x="38" y="{y+1}" width="105" height="18" rx="2" fill="#ffffff" stroke="#475569" stroke-width="1.1" />
        <polygon points="38,{y+12} 42,{y+10} 38,{y+8}" fill="#475569" />
        <text x="46" y="{y+14}" fill="#0f172a" font-size="9" font-weight="700">{k} [15:0]</text>
        <text x="138" y="{y+14}" fill="#94a3b8" font-size="7.5" text-anchor="end">K</text>

        <!-- Wires from p and k to multiplier -->
        <path d="M 143 {y-10} L 290 {y-4}" fill="none" stroke="#1e40af" stroke-width="1.3" />
        <path d="M 143 {y+10} L 290 {y+4}" fill="none" stroke="#1e40af" stroke-width="1.3" />

        <!-- Multiplier Symbol -->
        <circle cx="305" cy="{y}" r="14" fill="#ffffff" stroke="#1e40af" stroke-width="1.8" />
        <text x="305" y="{y+5}" fill="#1e40af" font-size="16" font-weight="700" text-anchor="middle">×</text>
        <text x="305" y="{y-16}" fill="#64748b" font-size="7" text-anchor="middle">16×16 DSP</text>

        <!-- Wire Mult -> Stage 1 Reg -->
        <line x1="319" y1="{y}" x2="385" y2="{y}" stroke="#1e40af" stroke-width="1.8" marker-end="url(#arrow-blue)" />
        <line x1="348" y1="{y-4}" x2="354" y2="{y+4}" stroke="#94a3b8" stroke-width="1" />
        <text x="355" y="{y-4}" fill="#64748b" font-size="7">32</text>

        <!-- Stage 1 Multiplier Register -->
        <rect x="385" y="{y-13}" width="160" height="26" rx="3" fill="#ffffff" stroke="#1e40af" stroke-width="1.5" filter="url(#shadow)" />
        <polygon points="385,{y+5} 390,{y} 385,{y-5}" fill="#1e40af" />
        <text x="395" y="{y+4}" fill="#0f172a" font-size="10" font-weight="700">{m} [31:0]</text>
        <text x="538" y="{y+4}" fill="#1e40af" font-size="7.5" text-anchor="end">DSP Reg</text>
        ''')

    # =========================================================================
    # 3. STAGE 2: ADDER TREE LEVEL 1 (s0_r..s3_r + m22_r2)
    # =========================================================================
    s_pairs = [
        ("s0_r", 0, 1, 306),
        ("s1_r", 2, 3, 442),
        ("s2_r", 4, 5, 578),
        ("s3_r", 6, 7, 714)
    ]

    for name, r1, r2, ay in s_pairs:
        y1 = row_y[r1]
        y2 = row_y[r2]
        svg.append(f'''
        <path d="M 545 {y1} L 600 {y1} L 610 {ay-6}" fill="none" stroke="#15803d" stroke-width="1.4" />
        <path d="M 545 {y2} L 600 {y2} L 610 {ay+6}" fill="none" stroke="#15803d" stroke-width="1.4" />

        <!-- Adder Symbol -->
        <circle cx="625" cy="{ay}" r="14" fill="#ffffff" stroke="#15803d" stroke-width="1.8" />
        <text x="625" y="{ay+5}" fill="#15803d" font-size="17" font-weight="700" text-anchor="middle">+</text>
        <text x="625" y="{ay-16}" fill="#64748b" font-size="7" text-anchor="middle">32+32</text>

        <!-- Adder -> Stage 2 Reg -->
        <line x1="639" y1="{ay}" x2="685" y2="{ay}" stroke="#15803d" stroke-width="1.8" marker-end="url(#arrow-green)" />
        <line x1="658" y1="{ay-4}" x2="664" y2="{ay+4}" stroke="#94a3b8" stroke-width="1" />
        <text x="665" y="{ay-4}" fill="#64748b" font-size="7">33</text>

        <rect x="685" y="{ay-13}" width="160" height="26" rx="3" fill="#ffffff" stroke="#15803d" stroke-width="1.5" filter="url(#shadow)" />
        <polygon points="685,{ay+5} 690,{ay} 685,{ay-5}" fill="#15803d" />
        <text x="695" y="{ay+4}" fill="#0f172a" font-size="10" font-weight="700">{name} [32:0]</text>
        <text x="838" y="{ay+4}" fill="#15803d" font-size="7.5" text-anchor="end">Tree L1</text>
        ''')

    # m22_r2 Delay Register
    y8 = row_y[8]
    svg.append(f'''
    <!-- m22_r2 Balance Reg -->
    <line x1="545" y1="{y8}" x2="685" y2="{y8}" stroke="#15803d" stroke-width="1.8" marker-end="url(#arrow-green)" />
    <rect x="685" y="{y8-13}" width="160" height="26" rx="3" fill="#ffffff" stroke="#15803d" stroke-width="1.5" stroke-dasharray="3 2" filter="url(#shadow)" />
    <polygon points="685,{y8+5} 690,{y8} 685,{y8-5}" fill="#15803d" />
    <text x="695" y="{y8+4}" fill="#0f172a" font-size="10" font-weight="700">m22_r2 [31:0]</text>
    <text x="838" y="{y8+4}" fill="#15803d" font-size="7.5" text-anchor="end">Balance Reg</text>
    ''')

    # =========================================================================
    # 4. STAGE 3: ADDER TREE LEVEL 2 (t0_r, t1_r + m22_r3)
    # =========================================================================
    t_pairs = [
        ("t0_r", 306, 442, 374),
        ("t1_r", 578, 714, 646)
    ]

    for name, y1, y2, ty in t_pairs:
        svg.append(f'''
        <path d="M 845 {y1} L 900 {y1} L 910 {ty-6}" fill="none" stroke="#c2410c" stroke-width="1.4" />
        <path d="M 845 {y2} L 900 {y2} L 910 {ty+6}" fill="none" stroke="#c2410c" stroke-width="1.4" />

        <!-- Adder Symbol -->
        <circle cx="925" cy="{ty}" r="14" fill="#ffffff" stroke="#c2410c" stroke-width="1.8" />
        <text x="925" y="{ty+5}" fill="#c2410c" font-size="17" font-weight="700" text-anchor="middle">+</text>
        <text x="925" y="{ty-16}" fill="#64748b" font-size="7" text-anchor="middle">33+33</text>

        <!-- Adder -> Stage 3 Reg -->
        <line x1="939" y1="{ty}" x2="985" y2="{ty}" stroke="#c2410c" stroke-width="1.8" marker-end="url(#arrow-orange)" />
        <line x1="958" y1="{ty-4}" x2="964" y2="{ty+4}" stroke="#94a3b8" stroke-width="1" />
        <text x="965" y="{ty-4}" fill="#64748b" font-size="7">34</text>

        <rect x="985" y="{ty-13}" width="160" height="26" rx="3" fill="#ffffff" stroke="#c2410c" stroke-width="1.5" filter="url(#shadow)" />
        <polygon points="985,{ty+5} 990,{ty} 985,{ty-5}" fill="#c2410c" />
        <text x="995" y="{ty+4}" fill="#0f172a" font-size="10" font-weight="700">{name} [33:0]</text>
        <text x="1138" y="{ty+4}" fill="#c2410c" font-size="7.5" text-anchor="end">Tree L2</text>
        ''')

    # m22_r3 Delay Register
    svg.append(f'''
    <!-- m22_r3 Balance Reg -->
    <line x1="845" y1="{y8}" x2="985" y2="{y8}" stroke="#c2410c" stroke-width="1.8" marker-end="url(#arrow-orange)" />
    <rect x="985" y="{y8-13}" width="160" height="26" rx="3" fill="#ffffff" stroke="#c2410c" stroke-width="1.5" stroke-dasharray="3 2" filter="url(#shadow)" />
    <polygon points="985,{y8+5} 990,{y8} 985,{y8-5}" fill="#c2410c" />
    <text x="995" y="{y8+4}" fill="#0f172a" font-size="10" font-weight="700">m22_r3 [31:0]</text>
    <text x="1138" y="{y8+4}" fill="#c2410c" font-size="7.5" text-anchor="end">Balance Reg</text>
    ''')

    # =========================================================================
    # 5. STAGE 4: FINAL ACCUMULATION & OUTPUT (y[35:0])
    # =========================================================================
    u0_y = 510
    final_y = 575

    svg.append(f'''
    <!-- t0_r and t1_r into u0 Adder -->
    <path d="M 1145 374 L 1210 374 L 1220 {u0_y-6}" fill="none" stroke="#6b21a8" stroke-width="1.5" />
    <path d="M 1145 646 L 1210 646 L 1220 {u0_y+6}" fill="none" stroke="#6b21a8" stroke-width="1.5" />

    <circle cx="1235" cy="{u0_y}" r="14" fill="#ffffff" stroke="#6b21a8" stroke-width="1.8" />
    <text x="1235" y="{u0_y+5}" fill="#6b21a8" font-size="17" font-weight="700" text-anchor="middle">+</text>
    <text x="1235" y="{u0_y-16}" fill="#64748b" font-size="7" text-anchor="middle">34+34 Adder</text>

    <!-- Intermediate wire u0 [34:0] -->
    <line x1="1249" y1="{u0_y}" x2="1310" y2="{final_y-6}" stroke="#6b21a8" stroke-width="1.8" />
    <text x="1268" y="{u0_y-4}" fill="#6b21a8" font-size="8.5" font-weight="700">u0 [34:0]</text>

    <!-- m22_r3 path into Final Adder -->
    <path d="M 1145 {y8} L 1290 {y8} L 1310 {final_y+6}" fill="none" stroke="#6b21a8" stroke-width="1.5" />
    <line x1="1215" y1="{y8-4}" x2="1221" y2="{y8+4}" stroke="#94a3b8" stroke-width="1" />
    <text x="1222" y="{y8-4}" fill="#64748b" font-size="7">32 (Sign-Ext /36)</text>

    <!-- Final Adder Symbol -->
    <circle cx="1325" cy="{final_y}" r="15" fill="#ffffff" stroke="#6b21a8" stroke-width="2" />
    <text x="1325" y="{final_y+5}" fill="#6b21a8" font-size="18" font-weight="700" text-anchor="middle">+</text>
    <text x="1325" y="{final_y-18}" fill="#64748b" font-size="7" text-anchor="middle">35+32 Final Adder</text>

    <!-- Final Adder -> Output Register y -->
    <line x1="1340" y1="{final_y}" x2="1395" y2="{final_y}" stroke="#6b21a8" stroke-width="2.2" marker-end="url(#arrow-purple)" />
    <line x1="1365" y1="{final_y-4}" x2="1371" y2="{final_y+4}" stroke="#94a3b8" stroke-width="1" />
    <text x="1372" y="{final_y-4}" fill="#64748b" font-size="7">36</text>

    <!-- Output Register y [35:0] -->
    <rect x="1395" y="{final_y-26}" width="165" height="52" rx="5" fill="#1e3a8a" stroke="#0f172a" stroke-width="2" filter="url(#shadow)" />
    <polygon points="1395,{final_y+7} 1402,{final_y} 1395,{final_y-7}" fill="#ffffff" />
    <text x="1477" y="{final_y-3}" fill="#ffffff" font-size="14" font-weight="700" text-anchor="middle">y [35:0]</text>
    <text x="1477" y="{final_y+13}" fill="#93c5fd" font-size="9" text-anchor="middle">Registered Output</text>

    <!-- Clock Enable from pipe[3] -->
    <path d="M 1317 170 L 1317 240 L 1477 240 L 1477 {final_y-26}" fill="none" stroke="#dc2626" stroke-width="1.2" stroke-dasharray="3 2" marker-end="url(#arrow)" />
    <text x="1400" y="234" fill="#dc2626" font-size="8" font-weight="700">Clock Enable: if (start_pipe[3])</text>
    ''')

    # =========================================================================
    # 6. BOTTOM LEGEND & PERFORMANCE SPECIFICATION BANNER
    # =========================================================================
    svg.append(f'''
    <!-- Bottom Legend Box -->
    <rect x="25" y="910" width="1550" height="58" rx="5" fill="#ffffff" stroke="#cbd5e1" stroke-width="1" filter="url(#shadow)" />
    
    <circle cx="50" cy="939" r="9" fill="#ffffff" stroke="#1e40af" stroke-width="1.5" />
    <text x="50" y="943" fill="#1e40af" font-size="12" font-weight="700" text-anchor="middle">×</text>
    <text x="66" y="943" fill="#0f172a" font-size="10" font-weight="600">DSP Multiplier (9 units, 16×16)</text>

    <circle cx="255" cy="939" r="9" fill="#ffffff" stroke="#15803d" stroke-width="1.5" />
    <text x="255" y="943" fill="#15803d" font-size="13" font-weight="700" text-anchor="middle">+</text>
    <text x="271" y="943" fill="#0f172a" font-size="10" font-weight="600">Pipelined Adder (7 units)</text>

    <rect x="435" y="929" width="30" height="20" rx="2" fill="#ffffff" stroke="#1e40af" stroke-width="1.4" />
    <polygon points="435,942 439,939 435,936" fill="#1e40af" />
    <text x="473" y="943" fill="#0f172a" font-size="10" font-weight="600">Pipeline Latch (D-FF Register)</text>

    <line x1="645" y1="939" x2="675" y2="939" stroke="#334155" stroke-width="1.5" />
    <line x1="657" y1="934" x2="663" y2="944" stroke="#64748b" stroke-width="1" />
    <text x="663" y="933" fill="#64748b" font-size="7.5">N</text>
    <text x="683" y="943" fill="#0f172a" font-size="10" font-weight="600">Bus with Bit-Width</text>

    <!-- Metrics Callout -->
    <rect x="830" y="918" width="735" height="42" rx="4" fill="#eff6ff" stroke="#bfdbfe" stroke-width="1" />
    <text x="842" y="933" fill="#1e40af" font-size="9.5" font-weight="700">TIMING CLOSURE &amp; HARDWARE METRICS (Intel Cyclone V 5CSXFC6D6F31C6, Quartus Prime 23.1):</text>
    <text x="842" y="947" fill="#1e3a8a" font-size="9">Fmax: 185.15 MHz (+142.2%) | Setup Slack: +4.599 ns (MET) | Hold Slack: +0.239 ns (MET) | Critical Path: 4.49 ns (0 Logic Levels) | 295 ALMs | 9 DSPs</text>
    ''')

    svg.append('</svg>')
    return '\n'.join(svg)

if __name__ == '__main__':
    svg_content = generate_svg()
    out_path = '02_optimized_v1_pipelining/results/microarchitecture_diagram.svg'
    with open(out_path, 'w', encoding='utf-8') as f:
        f.write(svg_content)
    print(f"Generated clean IEEE Microarchitecture Diagram: {out_path} ({len(svg_content)} bytes)")
