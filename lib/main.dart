// =====================================================================
//  MEU POSTINHO - App da disciplina EQS (Engenharia e Qualidade de Software)
// =====================================================================
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(const MeuPostinhoApp());

// ============================ CORES ============================
const kAzul = Color(0xFF1565C0);
const kAzulEscuro = Color(0xFF0D47A1);
const kAzulClaro = Color(0xFFDCE9FB);
const kFundo = Color(0xFFF3F6FA);
const kCinza = Color(0xFF6B6B6B);
const kVermelho = Color(0xFFD32F2F);

// ============================ MODELOS ============================
class Usuario {
  String nome, cpf, nascimento, sus, telefone, email, senha;
  Usuario({
    this.nome = '',
    this.cpf = '',
    this.nascimento = '',
    this.sus = '',
    this.telefone = '',
    this.email = '',
    this.senha = '',
  });
}

class Agendamento {
  final String medico, especialidade, data;
  String status; // Confirmada, Pendente ou Cancelada
  Agendamento(this.medico, this.especialidade, this.data, this.status);
}

class Remedio {
  final String nome, dose, hora;
  bool tomado;
  Remedio(this.nome, this.dose, this.hora, {this.tomado = false});
}

class Aviso {
  final String titulo, quando, texto;
  const Aviso(this.titulo, this.quando, this.texto);
}

// ===================== DADOS (em memória) =====================
class AppData {
  static Usuario usuario = Usuario(
    nome: 'Gabriel',
    cpf: '00000000000',
    nascimento: '01/01/2000',
    sus: '000000000000000',
    telefone: '81900000000',
    email: 'gabriel@email.com',
    senha: '123456',
  );

  static final List<Agendamento> agendamentos = [
    Agendamento('Dr. João Figueiredo', 'Cardiologista', '14 de Set - 15:30',
        'Confirmada'),
    Agendamento(
        'Dra. Maria Souza', 'Clínico Geral', '28 de Set - 09:00', 'Pendente'),
    Agendamento(
        'Dr. Carlos Lima', 'Odontologia', '02 de Out - 14:00', 'Cancelada'),
  ];

  static final List<Remedio> remedios = [
    Remedio('Losartana', '50mg • 1 comprimido', '08:00', tomado: true),
    Remedio('Dapaglifozina', '10mg • 1 comprimido', '08:00'),
    Remedio('Carvedilol', '25mg • 1 comprimido', '08:00'),
  ];

  static const List<Aviso> avisos = [
    Aviso('Campanha de vacinação', 'Hoje',
        'Vacinação contra a gripe para idosos e crianças. Traga o cartão de vacina.'),
    Aviso('Posto fechado na sexta', 'Ontem',
        'Não haverá atendimento na próxima sexta-feira por motivo de feriado.'),
    Aviso('Mutirão de exames', '10 Set',
        'Coleta de exames de sangue em jejum, das 7h às 9h.'),
    Aviso('Nova equipe de enfermagem', '05 Set',
        'Conheça os novos profissionais que atendem no seu posto.'),
  ];

  static const List<String> especialidades = [
    'Clínico Geral',
    'Cardiologia',
    'Pediatria',
    'Odontologia',
    'Enfermagem',
    'Nutrição'
  ];
  static const List<String> dias = [
    'Qua 11/11',
    'Qui 12/11',
    'Sex 13/11',
    'Seg 16/11',
    'Ter 17/11'
  ];
  static const List<String> horarios = [
    '08:00',
    '09:00',
    '10:30',
    '13:30',
    '15:00',
    '16:30'
  ];
  static const Map<String, String> medicos = {
    'Clínico Geral': 'Dra. Maria Souza',
    'Cardiologia': 'Dr. João Figueiredo',
    'Pediatria': 'Dra. Ana Lima',
    'Odontologia': 'Dr. Carlos Lima',
    'Enfermagem': 'Enf. Paula Rocha',
    'Nutrição': 'Dra. Júlia Melo',
  };

  static String primeiroNome() {
    final n = usuario.nome.trim();
    return n.isEmpty ? 'Paciente' : n.split(' ').first;
  }
}

// ============================ FUNÇÕES ÚTEIS ============================
Future<dynamic> abrir(BuildContext context, Widget pagina) =>
    Navigator.push(context, MaterialPageRoute(builder: (_) => pagina));

void mensagem(BuildContext context, String texto) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texto)));

String apenasNumeros(String v) => v.replaceAll(RegExp(r'\D'), '');

/// Aplica máscara usando # como número. Ex.: mascarar('12345678901', '###.###.###-##')
String mascarar(String valor, String mascara) {
  final d = apenasNumeros(valor);
  if (d.isEmpty) return valor;
  final b = StringBuffer();
  int i = 0;
  for (final ch in mascara.split('')) {
    if (i >= d.length) break;
    if (ch == '#') {
      b.write(d[i]);
      i++;
    } else {
      b.write(ch);
    }
  }
  return b.toString();
}

String dataPorExtenso(String dia, String hora) {
  const meses = [
    'Jan',
    'Fev',
    'Mar',
    'Abr',
    'Mai',
    'Jun',
    'Jul',
    'Ago',
    'Set',
    'Out',
    'Nov',
    'Dez'
  ];
  final p = dia.split(' ').last.split('/');
  return '${p[0]} de ${meses[int.parse(p[1]) - 1]} - $hora';
}

BoxDecoration cartao() => BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: const [
        BoxShadow(
            color: Color(0x14000000), blurRadius: 10, offset: Offset(0, 4))
      ],
    );

Future<bool> confirmar(
    BuildContext context, String titulo, String texto) async {
  final r = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(titulo),
      content: Text(texto),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Não')),
        TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Sim')),
      ],
    ),
  );
  return r ?? false;
}

// ============================ APP ============================
class MeuPostinhoApp extends StatelessWidget {
  const MeuPostinhoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meu Postinho',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: kAzul),
        useMaterial3: true,
        scaffoldBackgroundColor: kFundo,
      ),
      locale: const Locale('pt', 'BR'),
      supportedLocales: const [Locale('pt', 'BR')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const InicialPage(),
    );
  }
}


/// Imagem da pasta assets/images. Se o arquivo não existir, mostra o "fallback".
class AppImage extends StatelessWidget {
  final String nome;
  final double? width, height;
  final BoxFit fit;
  final Widget? fallback;
  const AppImage(this.nome,
      {super.key,
      this.width,
      this.height,
      this.fit = BoxFit.contain,
      this.fallback});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/$nome',
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (c, e, s) =>
          fallback ?? SizedBox(width: width, height: height),
    );
  }
}

class BotaoPrimario extends StatelessWidget {
  final String texto;
  final VoidCallback onPressed;
  final double? largura;
  final double altura;
  final Color cor;
  const BotaoPrimario({
    super.key,
    required this.texto,
    required this.onPressed,
    this.largura,
    this.altura = 54,
    this.cor = kAzul,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: largura ?? double.infinity,
      height: altura,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: cor,
          foregroundColor: Colors.white,
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: onPressed,
        child: Text(texto,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      ),
    );
  }
}

/// Logo + "Meu Postinho" + slogan (Tela Inicial e Login)
class LogoTitulo extends StatelessWidget {
  const LogoTitulo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppImage('logo.png',
            width: 110,
            height: 93,
            fallback: Icon(Icons.local_hospital, size: 80, color: kAzul)),
        SizedBox(height: 6),
        Text('Meu Postinho',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        SizedBox(height: 6),
        Text('Saúde mais perto de você.',
            style: TextStyle(fontSize: 16, color: kCinza)),
      ],
    );
  }
}

/// Faixa colorida do topo. Usa bandeira.png ou desenha uma onda colorida.
class BandeiraTopo extends StatelessWidget {
  const BandeiraTopo({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      width: double.infinity,
      child: AppImage('bandeira.png',
          fit: BoxFit.cover,
          width: double.infinity,
          height: 120,
          fallback:
              CustomPaint(painter: BandeiraPainter(), size: Size.infinite)),
    );
  }
}

class BandeiraPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const cores = [
      Color(0xFFE53935),
      Color(0xFFFBC02D),
      Color(0xFF43A047),
      Color(0xFF1E4FB5)
    ];
    final w = size.width, h = size.height;
    for (int i = 0; i < cores.length; i++) {
      final base = h * (1.0 - i * 0.18);
      final path = Path()
        ..moveTo(0, 0)
        ..lineTo(0, base * 0.55)
        ..cubicTo(w * 0.3, base, w * 0.6, base * 0.2, w, base * 0.45)
        ..lineTo(w, 0)
        ..close();
      canvas.drawPath(path, Paint()..color = cores[i]);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Desenho da cidade no rodapé (cidade.png)
class CidadeRodape extends StatelessWidget {
  const CidadeRodape({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppImage('cidade.png',
        width: double.infinity, fit: BoxFit.fitWidth);
  }
}

/// Recorte em onda usado no cabeçalho do Cadastro e da Home
class OndaClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size s) => Path()
    ..lineTo(0, s.height - 40)
    ..cubicTo(s.width * 0.3, s.height + 10, s.width * 0.6, s.height - 70,
        s.width, s.height - 20)
    ..lineTo(s.width, 0)
    ..close();

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class CabecalhoOnda extends StatelessWidget {
  final double altura;
  final Widget child;
  const CabecalhoOnda({super.key, required this.altura, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: OndaClipper(),
      child: Container(
        height: altura + MediaQuery.of(context).padding.top,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [kAzulEscuro, kAzul],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: SafeArea(bottom: false, child: child),
      ),
    );
  }
}

/// Cabeçalho azul com cantos arredondados (telas internas)
class CabecalhoPadrao extends StatelessWidget {
  final String titulo;
  final String? subtitulo;
  const CabecalhoPadrao({super.key, required this.titulo, this.subtitulo});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 140),
      padding: const EdgeInsets.fromLTRB(8, 0, 20, 28),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            colors: [kAzulEscuro, kAzul],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.only(top: 24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon:
                    const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                onPressed: () => Navigator.pop(context),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 6),
                    Text(titulo,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold)),
                    if (subtitulo != null) ...[
                      const SizedBox(height: 6),
                      Text(subtitulo!,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 15)),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Estrutura padrão das telas internas: cabeçalho + lista rolável
class TelaInterna extends StatelessWidget {
  final String titulo;
  final String? subtitulo;
  final List<Widget> filhos;
  const TelaInterna(
      {super.key, required this.titulo, this.subtitulo, required this.filhos});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CabecalhoPadrao(titulo: titulo, subtitulo: subtitulo),
          Expanded(
            child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                children: filhos),
          ),
        ],
      ),
    );
  }
}

/// Arco-íris decorativo no canto inferior direito
class FundoDecorado extends StatelessWidget {
  final Widget child;
  const FundoDecorado({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned(
            right: 0, bottom: 0, child: AppImage('arco_iris.png', width: 130)),
        child,
      ],
    );
  }
}

class ChipOpcao extends StatelessWidget {
  final String texto;
  final bool selecionado;
  final VoidCallback onTap;
  const ChipOpcao(
      {super.key,
      required this.texto,
      required this.selecionado,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selecionado ? kAzul : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: kAzul),
        ),
        child: Text(texto,
            style: TextStyle(
                color: selecionado ? Colors.white : kAzul,
                fontWeight: FontWeight.w500)),
      ),
    );
  }
}

class Selo extends StatelessWidget {
  final String status;
  const Selo(this.status, {super.key});

  @override
  Widget build(BuildContext context) {
    Color fundo;
    Color texto;
    if (status == 'Confirmada') {
      fundo = const Color(0xFFE3F4E6);
      texto = const Color(0xFF2E7D32);
    } else if (status == 'Pendente') {
      fundo = const Color(0xFFFFF3D6);
      texto = const Color(0xFFE69A00);
    } else {
      fundo = const Color(0xFFFDE2E2);
      texto = kVermelho;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration:
          BoxDecoration(color: fundo, borderRadius: BorderRadius.circular(20)),
      child: Text(status,
          style: TextStyle(
              color: texto, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }
}

// ============================ TELA INICIAL ============================
class InicialPage extends StatelessWidget {
  const InicialPage({super.key});

  void _perguntarCadastro(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: kAzul),
        ),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 42,
                backgroundColor: kAzulClaro,
                child: Icon(Icons.person_outline, size: 48, color: kAzulEscuro),
              ),
              const SizedBox(height: 16),
              const Text('Você já possui um cadastro?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF2E7D32),
                      side: const BorderSide(color: Color(0xFF2E7D32)),
                    ),
                    onPressed: () {
                      Navigator.pop(ctx);
                      abrir(context, const CadastroDadosPage());
                    },
                    child: const Text('Não'),
                  ),
                  const SizedBox(width: 24),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: kAzul,
                      side: const BorderSide(color: kAzul),
                    ),
                    onPressed: () {
                      Navigator.pop(ctx);
                      abrir(context, const LoginPage());
                    },
                    child: const Text('Sim'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned(top: 0, left: 0, right: 0, child: BandeiraTopo()),
          const Positioned(bottom: 0, left: 0, right: 0, child: CidadeRodape()),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const LogoTitulo(),
                    const SizedBox(height: 120),
                    BotaoPrimario(
                        texto: 'Começar',
                        onPressed: () => _perguntarCadastro(context)),
                    const SizedBox(height: 140),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================ LOGIN ============================
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _email = TextEditingController();
  final _senha = TextEditingController();
  bool _verSenha = false;
  bool _lembrar = false;

  void _entrar() {
    final email = _email.text.trim().toLowerCase();
    final senha = _senha.text;
    if (email.isEmpty || senha.isEmpty) {
      mensagem(context, 'Preencha e-mail e senha.');
      return;
    }
    if (email == AppData.usuario.email.toLowerCase() &&
        senha == AppData.usuario.senha) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const PrincipalPage()),
          (r) => false);
    } else {
      mensagem(context, 'E-mail ou senha incorretos.');
    }
  }

  void _esqueciSenha() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Recuperar senha'),
        content:
            const Text('Enviamos as instruções para o seu e-mail cadastrado.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('OK'))
        ],
      ),
    );
  }

  Widget _campo(TextEditingController c, String dica, IconData icone,
      {bool senha = false}) {
    return TextField(
      controller: c,
      obscureText: senha && !_verSenha,
      keyboardType:
          senha ? TextInputType.visiblePassword : TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: dica,
        prefixIcon: Icon(icone),
        suffixIcon: senha
            ? IconButton(
                icon: Icon(_verSenha
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined),
                onPressed: () => setState(() => _verSenha = !_verSenha),
              )
            : null,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF9E9E9E)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: kAzul, width: 2),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned(top: 0, left: 0, right: 0, child: BandeiraTopo()),
          const Positioned(bottom: 0, left: 0, right: 0, child: CidadeRodape()),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  const SizedBox(height: 100),
                  const LogoTitulo(),
                  const SizedBox(height: 40),
                  _campo(_email, 'E-mail', Icons.mail_outline),
                  const SizedBox(height: 20),
                  _campo(_senha, 'Senha', Icons.lock_outline, senha: true),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: _esqueciSenha,
                    child: const Text('Esqueci minha senha!',
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: kAzul,
                            decoration: TextDecoration.underline)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                          value: _lembrar,
                          onChanged: (v) =>
                              setState(() => _lembrar = v ?? false)),
                      const Text('Lembrar de mim',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  BotaoPrimario(
                      texto: 'Entrar', largura: 202, onPressed: _entrar),
                  const SizedBox(height: 14),
                  BotaoPrimario(
                    texto: 'Criar Conta',
                    largura: 202,
                    onPressed: () => abrir(context, const CadastroDadosPage()),
                  ),
                  const SizedBox(height: 200),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================ CADASTRO (3 etapas) ============================
class CampoCadastro extends StatelessWidget {
  final IconData icone;
  final String rotulo, dica;
  final TextEditingController controller;
  final TextInputType teclado;
  final bool oculto;
  final Widget? sufixo;
  final bool somenteLeitura;
  final VoidCallback? onTap;
  final List<TextInputFormatter>? formatadores;

  const CampoCadastro({
    super.key,
    required this.icone,
    required this.rotulo,
    required this.dica,
    required this.controller,
    this.teclado = TextInputType.text,
    this.oculto = false,
    this.sufixo,
    this.somenteLeitura = false,
    this.onTap,
    this.formatadores,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icone, color: kAzul, size: 26),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(rotulo,
                    style: const TextStyle(
                        color: kAzul,
                        fontSize: 16,
                        fontWeight: FontWeight.w600)),
                TextField(
                  controller: controller,
                  keyboardType: teclado,
                  obscureText: oculto,
                  readOnly: somenteLeitura,
                  onTap: onTap,
                  inputFormatters: formatadores,
                  decoration: InputDecoration(
                    hintText: dica,
                    suffixIcon: sufixo,
                    enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF9E9E9E))),
                    focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: kAzul, width: 2)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CadastroBase extends StatelessWidget {
  final String titulo, subtitulo, textoBotao;
  final List<Widget> campos;
  final VoidCallback onContinuar;

  const CadastroBase({
    super.key,
    required this.titulo,
    required this.subtitulo,
    required this.campos,
    required this.onContinuar,
    this.textoBotao = 'Continuar',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FundoDecorado(
        child: Column(
          children: [
            CabecalhoOnda(
              altura: 180,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new,
                          color: Colors.white, size: 28),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top: 6),
                        child: Text('Cadastro',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
                children: [
                  Text(titulo,
                      style: const TextStyle(
                          color: kAzul,
                          fontSize: 28,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(subtitulo,
                      style: const TextStyle(color: kAzul, fontSize: 16)),
                  const SizedBox(height: 28),
                  ...campos,
                  const SizedBox(height: 16),
                  Center(
                      child: BotaoPrimario(
                          texto: textoBotao,
                          largura: 202,
                          onPressed: onContinuar)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------- Etapa 1: dados pessoais ----------
class CadastroDadosPage extends StatefulWidget {
  const CadastroDadosPage({super.key});

  @override
  State<CadastroDadosPage> createState() => _CadastroDadosPageState();
}

class _CadastroDadosPageState extends State<CadastroDadosPage> {
  final _nome = TextEditingController();
  final _cpf = TextEditingController();
  final _nasc = TextEditingController();
  final _sus = TextEditingController();

  Future<void> _escolherData() async {
    final d = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale('pt', 'BR'),
    );
    if (d != null) {
      _nasc.text =
          '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
    }
  }

  void _continuar() {
    if (_nome.text.trim().isEmpty ||
        _cpf.text.isEmpty ||
        _nasc.text.isEmpty ||
        _sus.text.isEmpty) {
      mensagem(context, 'Preencha todos os campos.');
      return;
    }
    if (_cpf.text.length != 11) {
      mensagem(context, 'O CPF deve ter 11 números.');
      return;
    }
    if (_sus.text.length != 15) {
      mensagem(context, 'O Cartão SUS deve ter 15 números.');
      return;
    }
    final u = Usuario(
        nome: _nome.text.trim(),
        cpf: _cpf.text,
        nascimento: _nasc.text,
        sus: _sus.text);
    abrir(context, CadastroContatoPage(usuario: u));
  }

  @override
  Widget build(BuildContext context) {
    return CadastroBase(
      titulo: 'Vamos começar!',
      subtitulo: 'Preencha as informações abaixo para continuar',
      onContinuar: _continuar,
      campos: [
        CampoCadastro(
            icone: Icons.person_outline,
            rotulo: 'Nome Completo',
            dica: 'Digite seu nome',
            controller: _nome),
        CampoCadastro(
          icone: Icons.lock_outline,
          rotulo: 'CPF',
          dica: 'Digite seu CPF (só números)',
          controller: _cpf,
          teclado: TextInputType.number,
          formatadores: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(11)
          ],
        ),
        CampoCadastro(
          icone: Icons.calendar_month_outlined,
          rotulo: 'Data de Nascimento',
          dica: 'DD/MM/AAAA',
          controller: _nasc,
          somenteLeitura: true,
          onTap: _escolherData,
          sufixo: const Icon(Icons.calendar_month, color: kAzul),
        ),
        CampoCadastro(
          icone: Icons.credit_card,
          rotulo: 'Cartão SUS',
          dica: 'Digite o número do seu cartão SUS',
          controller: _sus,
          teclado: TextInputType.number,
          formatadores: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(15)
          ],
        ),
      ],
    );
  }
}

// ---------- Etapa 2: contatos ----------
class CadastroContatoPage extends StatefulWidget {
  final Usuario usuario;
  const CadastroContatoPage({super.key, required this.usuario});

  @override
  State<CadastroContatoPage> createState() => _CadastroContatoPageState();
}

class _CadastroContatoPageState extends State<CadastroContatoPage> {
  final _tel = TextEditingController();
  final _email = TextEditingController();

  void _continuar() {
    if (_tel.text.length < 10) {
      mensagem(context, 'Digite um telefone válido com DDD.');
      return;
    }
    if (!_email.text.contains('@') || !_email.text.contains('.')) {
      mensagem(context, 'Digite um e-mail válido.');
      return;
    }
    widget.usuario.telefone = _tel.text;
    widget.usuario.email = _email.text.trim();
    abrir(context, CadastroSenhaPage(usuario: widget.usuario));
  }

  @override
  Widget build(BuildContext context) {
    return CadastroBase(
      titulo: 'Seus contatos!',
      subtitulo:
          'Informe seus dados de contato para receber informações e lembretes.',
      onContinuar: _continuar,
      campos: [
        CampoCadastro(
          icone: Icons.phone_outlined,
          rotulo: 'Telefone',
          dica: '(00) 00000-0000 (só números)',
          controller: _tel,
          teclado: TextInputType.phone,
          formatadores: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(11)
          ],
        ),
        CampoCadastro(
          icone: Icons.mail_outline,
          rotulo: 'E-mail',
          dica: 'Digite seu E-mail',
          controller: _email,
          teclado: TextInputType.emailAddress,
        ),
      ],
    );
  }
}

// ---------- Etapa 3: senha ----------
class CadastroSenhaPage extends StatefulWidget {
  final Usuario usuario;
  const CadastroSenhaPage({super.key, required this.usuario});

  @override
  State<CadastroSenhaPage> createState() => _CadastroSenhaPageState();
}

class _CadastroSenhaPageState extends State<CadastroSenhaPage> {
  final _senha = TextEditingController();
  final _confirma = TextEditingController();
  bool _ver1 = false, _ver2 = false;

  void _finalizar() {
    if (_senha.text.length < 6) {
      mensagem(context, 'A senha deve ter pelo menos 6 caracteres.');
      return;
    }
    if (_senha.text != _confirma.text) {
      mensagem(context, 'As senhas não conferem.');
      return;
    }
    widget.usuario.senha = _senha.text;
    AppData.usuario = widget.usuario;
    final messenger = ScaffoldMessenger.of(context);
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (_) => const PrincipalPage()), (r) => false);
    messenger.showSnackBar(
        const SnackBar(content: Text('Cadastro realizado com sucesso!')));
  }

  @override
  Widget build(BuildContext context) {
    return CadastroBase(
      titulo: 'Crie sua senha!',
      subtitulo: 'Escolha uma senha segura para proteger sua conta.',
      textoBotao: 'Finalizar',
      onContinuar: _finalizar,
      campos: [
        CampoCadastro(
          icone: Icons.lock_outline,
          rotulo: 'Senha',
          dica: 'Digite sua senha',
          controller: _senha,
          oculto: !_ver1,
          sufixo: IconButton(
            icon: Icon(_ver1
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined),
            onPressed: () => setState(() => _ver1 = !_ver1),
          ),
        ),
        CampoCadastro(
          icone: Icons.lock_outline,
          rotulo: 'Confirmar Senha',
          dica: 'Confirme sua senha',
          controller: _confirma,
          oculto: !_ver2,
          sufixo: IconButton(
            icon: Icon(_ver2
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined),
            onPressed: () => setState(() => _ver2 = !_ver2),
          ),
        ),
      ],
    );
  }
}

// ============================ PRINCIPAL (com abas) ============================
class PrincipalPage extends StatefulWidget {
  const PrincipalPage({super.key});

  @override
  State<PrincipalPage> createState() => _PrincipalPageState();
}

class _PrincipalPageState extends State<PrincipalPage> {
  int _aba = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _aba == 0 ? const ServicosAba() : const MeuDiaAba(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _aba,
        selectedItemColor: kAzul,
        onTap: (i) => setState(() => _aba = i),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.grid_view_outlined),
              activeIcon: Icon(Icons.grid_view_rounded),
              label: 'Início'),
          BottomNavigationBarItem(
              icon: Icon(Icons.today_outlined),
              activeIcon: Icon(Icons.today),
              label: 'Meu dia'),
        ],
      ),
    );
  }
}

Widget saudacao(String linha2) => Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Olá, ${AppData.primeiroNome()}',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(linha2,
              style: const TextStyle(color: Colors.white, fontSize: 16)),
        ],
      ),
    );

Widget faixaTitulo(String texto) => Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
          color: kAzulClaro, borderRadius: BorderRadius.circular(8)),
      child: Text(texto,
          style: const TextStyle(
              color: kAzul, fontSize: 18, fontWeight: FontWeight.w600)),
    );

// ---------- Aba "Início": menu de serviços ----------
class ServicosAba extends StatefulWidget {
  const ServicosAba({super.key});

  @override
  State<ServicosAba> createState() => _ServicosAbaState();
}

class _ServicosAbaState extends State<ServicosAba> {
  void _ir(Widget pagina) =>
      abrir(context, pagina).then((_) => setState(() {}));

  @override
  Widget build(BuildContext context) {
    final ultimoAviso = AppData.avisos.first;
    return FundoDecorado(
      child: Column(
        children: [
          CabecalhoOnda(
              altura: 150, child: saudacao('Bem-vindo(a) ao seu Postinho.')),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              children: [
                faixaTitulo('O que você procura hoje ?'),
                const SizedBox(height: 20),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 169 / 128,
                  children: [
                    CartaoMenu(
                        titulo: 'Agendar\nConsulta',
                        icone: Icons.event_available,
                        cor: kAzul,
                        corTexto: Colors.white,
                        onTap: () => _ir(const AgendarPage())),
                    CartaoMenu(
                        titulo: 'Meus\nAgendamentos',
                        icone: Icons.calendar_month,
                        cor: const Color(0xFFC9DAF0),
                        corTexto: kAzul,
                        onTap: () => _ir(const MeusAgendamentosPage())),
                    CartaoMenu(
                        titulo: 'Medicamentos',
                        icone: Icons.medication_outlined,
                        cor: const Color(0xFFF8EDD1),
                        corTexto: Colors.black87,
                        onTap: () => _ir(const MedicamentosPage())),
                    CartaoMenu(
                        titulo: 'Avisos',
                        icone: Icons.notifications_none,
                        cor: const Color(0xFFF1D9DA),
                        corTexto: Colors.black87,
                        onTap: () => _ir(const AvisosPage())),
                    CartaoMenu(
                        titulo: 'Minha Unidade',
                        icone: Icons.local_hospital_outlined,
                        cor: const Color(0xFFD3EDE2),
                        corTexto: Colors.black87,
                        onTap: () => _ir(const UnidadePage())),
                    CartaoMenu(
                        titulo: 'Perfil',
                        icone: Icons.person_outline,
                        cor: const Color(0xFFDED9FB),
                        corTexto: Colors.black87,
                        onTap: () => _ir(const PerfilPage())),
                  ],
                ),
                const SizedBox(height: 20),
                Material(
                  color: kAzulClaro,
                  borderRadius: BorderRadius.circular(16),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => _ir(const AvisosPage()),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Avisos!',
                              style: TextStyle(
                                  color: kAzul,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          Text(ultimoAviso.titulo,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 4),
                          Text(ultimoAviso.texto,
                              style: const TextStyle(color: kCinza)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CartaoMenu extends StatelessWidget {
  final String titulo;
  final IconData icone;
  final Color cor, corTexto;
  final VoidCallback onTap;
  const CartaoMenu({
    super.key,
    required this.titulo,
    required this.icone,
    required this.cor,
    required this.corTexto,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: cor,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icone, color: corTexto, size: 30),
              const Spacer(),
              Text(titulo,
                  style: TextStyle(
                      color: corTexto,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      height: 1.2)),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------- Aba "Meu dia": próxima consulta + remédios ----------
class MeuDiaAba extends StatefulWidget {
  const MeuDiaAba({super.key});

  @override
  State<MeuDiaAba> createState() => _MeuDiaAbaState();
}

class _MeuDiaAbaState extends State<MeuDiaAba> {
  void _ir(Widget pagina) =>
      abrir(context, pagina).then((_) => setState(() {}));

  Agendamento? _proxima() {
    for (final a in AppData.agendamentos) {
      if (a.status != 'Cancelada') return a;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final prox = _proxima();
    return FundoDecorado(
      child: Column(
        children: [
          CabecalhoOnda(
              altura: 150, child: saudacao('Como você está se sentindo hoje?')),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              children: [
                faixaTitulo('Próxima consulta'),
                const SizedBox(height: 16),
                if (prox == null) ...[
                  const Text('Nenhuma consulta agendada.',
                      style: TextStyle(color: kCinza)),
                  const SizedBox(height: 12),
                  BotaoPrimario(
                      texto: 'Agendar consulta',
                      altura: 46,
                      onPressed: () => _ir(const AgendarPage())),
                ] else ...[
                  Row(
                    children: [
                      ClipOval(
                        child: prox.medico == 'Dr. João Figueiredo'
                            ? const AppImage('medico.png',
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                fallback: CircleAvatar(
                                    radius: 40,
                                    backgroundColor: kAzulClaro,
                                    child: Icon(Icons.person,
                                        color: kAzul, size: 40)))
                            : const CircleAvatar(
                                radius: 40,
                                backgroundColor: kAzulClaro,
                                child:
                                    Icon(Icons.person, color: kAzul, size: 40)),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(prox.medico,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 4),
                            Text(prox.especialidade,
                                style: const TextStyle(color: kCinza)),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.calendar_month,
                                    color: kAzul, size: 20),
                                const SizedBox(width: 6),
                                Text(prox.data),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Align(
                    alignment: Alignment.centerRight,
                    child: BotaoPrimario(
                      texto: 'Ver detalhes',
                      largura: 260,
                      altura: 46,
                      onPressed: () => _ir(const MeusAgendamentosPage()),
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Text('Remédios de hoje',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600)),
                    const Spacer(),
                    TextButton(
                      onPressed: () => _ir(const MedicamentosPage()),
                      child: const Text('Ver todos',
                          style: TextStyle(fontSize: 16, color: kAzul)),
                    ),
                  ],
                ),
                ...AppData.remedios.map((r) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 26,
                            backgroundColor: Color(0xFFBBD6F7),
                            child: Icon(Icons.medication, color: kAzul),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(r.nome,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600)),
                                Text(r.dose,
                                    style: const TextStyle(color: kCinza)),
                                Text(r.hora,
                                    style: const TextStyle(
                                        color: kCinza, fontSize: 13)),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                                r.tomado
                                    ? Icons.check_circle
                                    : Icons.radio_button_unchecked,
                                color: r.tomado ? kAzul : Colors.grey),
                            onPressed: () =>
                                setState(() => r.tomado = !r.tomado),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================ AGENDAR CONSULTA ============================
class AgendarPage extends StatefulWidget {
  const AgendarPage({super.key});

  @override
  State<AgendarPage> createState() => _AgendarPageState();
}

class _AgendarPageState extends State<AgendarPage> {
  String? _esp, _dia, _hora;

  Widget _grupo(String titulo, List<String> opcoes, String? atual,
      ValueChanged<String> escolher) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: opcoes
                .map((o) => ChipOpcao(
                    texto: o,
                    selecionado: o == atual,
                    onTap: () => escolher(o)))
                .toList(),
          ),
        ],
      ),
    );
  }

  void _confirmar() {
    if (_esp == null || _dia == null || _hora == null) {
      mensagem(context, 'Escolha a especialidade, o dia e o horário.');
      return;
    }
    AppData.agendamentos.add(Agendamento(
      AppData.medicos[_esp!] ?? 'Profissional do posto',
      _esp!,
      dataPorExtenso(_dia!, _hora!),
      'Pendente',
    ));
    final messenger = ScaffoldMessenger.of(context);
    Navigator.pop(context);
    messenger.showSnackBar(const SnackBar(
        content: Text('Consulta agendada! Veja em "Meus Agendamentos".')));
  }

  @override
  Widget build(BuildContext context) {
    return TelaInterna(
      titulo: 'Agendar consulta',
      subtitulo: 'Escolha a especialidade, o dia e o horário',
      filhos: [
        _grupo('Especialidade', AppData.especialidades, _esp,
            (v) => setState(() => _esp = v)),
        _grupo('Dia', AppData.dias, _dia, (v) => setState(() => _dia = v)),
        _grupo('Horário', AppData.horarios, _hora,
            (v) => setState(() => _hora = v)),
        BotaoPrimario(texto: 'Confirmar agendamento', onPressed: _confirmar),
      ],
    );
  }
}

// ============================ MEUS AGENDAMENTOS ============================
class MeusAgendamentosPage extends StatefulWidget {
  const MeusAgendamentosPage({super.key});

  @override
  State<MeusAgendamentosPage> createState() => _MeusAgendamentosPageState();
}

class _MeusAgendamentosPageState extends State<MeusAgendamentosPage> {
  Future<void> _cancelar(Agendamento a) async {
    final ok = await confirmar(context, 'Cancelar consulta',
        'Deseja cancelar a consulta com ${a.medico}?');
    if (ok) setState(() => a.status = 'Cancelada');
  }

  @override
  Widget build(BuildContext context) {
    return TelaInterna(
      titulo: 'Meus agendamentos',
      filhos: [
        ...AppData.agendamentos.map((a) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: cartao(),
              child: Column(
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 32,
                        backgroundColor: kAzulClaro,
                        child:
                            Icon(Icons.person_outline, color: kAzul, size: 32),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(a.medico,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 2),
                            Text(a.especialidade,
                                style: const TextStyle(color: kCinza)),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.calendar_today,
                                    color: kAzul, size: 16),
                                const SizedBox(width: 6),
                                Text(a.data,
                                    style: const TextStyle(fontSize: 13)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Selo(a.status),
                      const Spacer(),
                      if (a.status != 'Cancelada')
                        TextButton(
                          onPressed: () => _cancelar(a),
                          child: const Text('Cancelar',
                              style: TextStyle(
                                  color: kVermelho,
                                  fontWeight: FontWeight.w600)),
                        ),
                    ],
                  ),
                ],
              ),
            )),
        const SizedBox(height: 8),
        BotaoPrimario(
          texto: 'Agendar nova consulta',
          onPressed: () =>
              abrir(context, const AgendarPage()).then((_) => setState(() {})),
        ),
      ],
    );
  }
}

// ============================ MEDICAMENTOS ============================
class MedicamentosPage extends StatefulWidget {
  const MedicamentosPage({super.key});

  @override
  State<MedicamentosPage> createState() => _MedicamentosPageState();
}

class _MedicamentosPageState extends State<MedicamentosPage> {
  @override
  Widget build(BuildContext context) {
    final total = AppData.remedios.length;
    final tomados = AppData.remedios.where((r) => r.tomado).length;
    return TelaInterna(
      titulo: 'Medicamentos',
      subtitulo: '$tomados de $total tomados hoje',
      filhos: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: total == 0 ? 0 : tomados / total,
            minHeight: 8,
            backgroundColor: kAzulClaro,
            color: kAzul,
          ),
        ),
        const SizedBox(height: 16),
        ...AppData.remedios.map((r) => GestureDetector(
              onTap: () => setState(() => r.tomado = !r.tomado),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: cartao(),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 25,
                      backgroundColor: kAzulClaro,
                      child: Icon(Icons.medication, color: kAzul),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(r.nome,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          Text(r.dose, style: const TextStyle(color: kCinza)),
                          Text('Hoje às ${r.hora}',
                              style:
                                  const TextStyle(color: kCinza, fontSize: 13)),
                        ],
                      ),
                    ),
                    r.tomado
                        ? const Icon(Icons.check_circle,
                            color: Color(0xFF2E7D32), size: 30)
                        : Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.grey, width: 2),
                            ),
                          ),
                  ],
                ),
              ),
            )),
        const Text('Toque em um remédio para marcar como tomado.',
            textAlign: TextAlign.center, style: TextStyle(color: kCinza)),
      ],
    );
  }
}

// ============================ AVISOS ============================
class AvisosPage extends StatelessWidget {
  const AvisosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return TelaInterna(
      titulo: 'Avisos',
      subtitulo: 'Fique por dentro das novidades do posto',
      filhos: AppData.avisos
          .map((a) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: cartao(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.notifications_none,
                            color: kAzul, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(a.titulo,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600)),
                        ),
                        Text(a.quando,
                            style:
                                const TextStyle(color: kCinza, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(a.texto, style: const TextStyle(color: kCinza)),
                  ],
                ),
              ))
          .toList(),
    );
  }
}

// ============================ MINHA UNIDADE ============================
class UnidadePage extends StatelessWidget {
  const UnidadePage({super.key});

  static const _endereco = 'Rua Exemplo, 123 - Recife, PE';
  static const _telefone = '(81) 3000-0000';

  Widget _linha(IconData icone, String texto) => Padding(
        padding: const EdgeInsets.only(top: 14),
        child: Row(
          children: [
            Icon(icone, color: kAzul, size: 22),
            const SizedBox(width: 12),
            Expanded(child: Text(texto, style: const TextStyle(fontSize: 15))),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return TelaInterna(
      titulo: 'Minha Unidade',
      filhos: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: cartao(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('UBS Meu Postinho',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              _linha(Icons.location_on_outlined, _endereco),
              _linha(Icons.access_time, 'Seg a Sex, 7h às 17h'),
              _linha(Icons.phone_outlined, _telefone),
            ],
          ),
        ),
        const SizedBox(height: 16),
        BotaoPrimario(
          texto: 'Como chegar',
          onPressed: () => mensagem(context, 'Endereço: $_endereco'),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 54,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: kAzul,
              side: const BorderSide(color: kAzul, width: 1.5),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Clipboard.setData(const ClipboardData(text: _telefone));
              mensagem(context,
                  'Número $_telefone copiado. Cole no discador para ligar.');
            },
            child: const Text('Ligar para o posto',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ),
        ),
      ],
    );
  }
}

// ============================ PERFIL ============================
class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key});

  Widget _linha(IconData icone, String rotulo, String valor) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Icon(icone, color: kAzul, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(rotulo,
                      style: const TextStyle(color: kCinza, fontSize: 12)),
                  const SizedBox(height: 2),
                  Text(valor, style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ],
        ),
      );

  Future<void> _sair(BuildContext context) async {
    final ok = await confirmar(context, 'Sair', 'Deseja sair da sua conta?');
    if (ok && context.mounted) {
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (_) => const LoginPage()), (r) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final u = AppData.usuario;
    return TelaInterna(
      titulo: 'Perfil',
      filhos: [
        const Center(
          child: CircleAvatar(
            radius: 48,
            backgroundColor: kAzulClaro,
            child: Icon(Icons.person_outline, color: kAzul, size: 48),
          ),
        ),
        const SizedBox(height: 10),
        Text(u.nome,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: cartao(),
          child: Column(
            children: [
              _linha(Icons.badge_outlined, 'CPF',
                  mascarar(u.cpf, '###.###.###-##')),
              _linha(Icons.credit_card, 'Cartão SUS',
                  mascarar(u.sus, '### #### #### ####')),
              _linha(Icons.phone_outlined, 'Telefone',
                  mascarar(u.telefone, '(##) #####-####')),
              _linha(Icons.mail_outline, 'E-mail', u.email),
            ],
          ),
        ),
        const SizedBox(height: 16),
        BotaoPrimario(
            texto: 'Sair', cor: kVermelho, onPressed: () => _sair(context)),
      ],
    );
  }
}
