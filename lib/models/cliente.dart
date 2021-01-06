class Cliente{
  String nome;
  String telefone;

  Cliente();

  Cliente.fromNomeDescricao(String nome, String telefone){
    this.nome = nome;
    this.telefone = telefone;
  }

  Cliente.fromJson(Map<String, dynamic> json):
      nome = json['nome'],
      telefone = json['telefone'];

  Map toJson() => {
    'nome': nome,
    'telefone': telefone
  };
}