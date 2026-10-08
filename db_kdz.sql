USE db_kdz;
CREATE TABLE IF NOT EXISTS gerente 
( 
 id_gerente INT PRIMARY KEY,  
 nome_gerente VARCHAR(100) NOT NULL,  
 email_gerente VARCHAR(100) NOT NULL,  
 cpf_gerente VARCHAR(12) NOT NULL,  
 telefone_gerente VARCHAR(14) NOT NULL,
 senha_gerente VARCHAR(225) NOT NULL
); 

CREATE TABLE IF NOT EXISTS gerencia_gerente_funcionario 
( 
 id_gerente_funcionario INT PRIMARY KEY AUTO_INCREMENT,  
 id_funcionario INT,  
 id_gerente INT  
); 

CREATE TABLE IF NOT EXISTS gerencia_gerente_produto 
( 
 id_gerente_produto INT PRIMARY KEY AUTO_INCREMENT,  
 id_produto INT,  
 id_gerente INT  
); 

ALTER TABLE gerencia_gerente_funcionario ADD FOREIGN KEY(id_funcionario) REFERENCES funcionario (id_funcionario);
ALTER TABLE gerencia_gerente_funcionario ADD FOREIGN KEY(id_gerente) REFERENCES gerente (id_gerente);
ALTER TABLE gerencia_gerente_produto ADD FOREIGN KEY(id_produto) REFERENCES produto (id_produto);
ALTER TABLE gerencia_gerente_produto ADD FOREIGN KEY(id_gerente) REFERENCES gerente (id_gerente);
