# Instalação Facilitada do PJe-Office Pro

Repositório: [hudsonalbuquerque97-sys/Pje_office_scritps_instala-o](https://github.com/hudsonalbuquerque97-sys/Pje_office_scritps_instala-o)

Este repositório contém **dois scripts** que automatizam a preparação do ambiente para uso do **PJe-Office Pro**, incluindo o reconhecimento do **token GD** (SafeSign) em distribuições baseadas em Debian.

---

## Objetivo

Facilitar a instalação do PJe-Office Pro em sistemas **Linux Mint 22.1**, **Ubuntu**, **Debian** e derivados, garantindo que todas as dependências e drivers necessários sejam configurados corretamente.

---

## Scripts

### 1️⃣ `instala_token_safesign.sh`
- **Função:**  
  - Instala o driver **SafeSign** para que o sistema reconheça o token GD.  
  - Corrige e instala dependências ausentes (a partir do Mint 22.1, Ubuntu, Debian e derivados).

### 2️⃣ `Instalador_pje_office_pro.sh`
- **Função:**  
  - Baixa e instala a versão mais recente do **PJe-Office Pro**.  
  - Cria automaticamente um **atalho na Área de Trabalho** para execução rápida.

---

## Como usar

Clone o repositório, conceda permissão de execução e rode os scripts **nessa ordem**:

```bash
# 1. Clonar o repositório
git clone https://github.com/hudsonalbuquerque97-sys/Pje_office_scritps_instala-o.git
cd Pje_office_scritps_instala-o

# 2. Dar permissão de execução
chmod +x instala_token_safesign.sh
chmod +x Instalador_pje_office_pro.sh

# 3. Executar os scripts
./instala_token_safesign.sh
./Instalador_pje_office_pro.sh

