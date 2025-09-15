import sys
import json
import time
import re
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.chrome.options import Options

def baixar_json_de_url_com_selenium(url):
    """
    Usa o Selenium para navegar até a URL e capturar o JSON
    após a resolução do desafio de segurança.
    """
    #print(f"Buscando dados em: {url}")
    
    options = Options()
    # Adiciona a flag para que o Selenium capture o log de desempenho
    #options.add_argument("--headless")
    options.set_capability("goog:loggingPrefs", {"performance": "ALL"})
    
    try:
        service = Service(ChromeDriverManager().install())
        driver = webdriver.Chrome(service=service, options=options)
        
        # Acessa a URL
        driver.get(url)
        
        # Espera um tempo para o JavaScript ser executado e o JSON ser carregado
        time.sleep(5)
        
        # Coleta os logs de desempenho para inspecionar as requisições
        logs = driver.get_log("performance")
        
        for log in logs:
            message = json.loads(log["message"])["message"]
            if "Network.responseReceived" == message["method"]:
                # Pega a URL da requisição
                request_url = message["params"]["response"]["url"]
                
                # Verifica se a URL da requisição contém o padrão do JSON
                if re.search(r'historico-rentabilidade/\d+\?days=\d+', request_url):
                    request_id = message["params"]["requestId"]
                    try:
                        # Tenta pegar o corpo da resposta da requisição
                        response_body = driver.execute_cdp_cmd(
                            "Network.getResponseBody", {"requestId": request_id}
                        )["body"]
                        
                        # Decodifica e retorna o JSON
                        return json.loads(response_body)
                    except Exception as e:
                        # Ignora erros em requisições que não têm corpo
                        continue
                        
    except Exception as e:
        print(f"Erro ao processar a página: {e}")
        return None
    finally:
        driver.quit()

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Uso: python baixar_json_selenium.py <URL>")
        sys.exit(1)
    
    url = sys.argv[1]
    
    json_data = baixar_json_de_url_com_selenium(url)
    
    if json_data:
        #print("\n--- Conteúdo JSON Baixado ---\n")
        print(json.dumps(json_data, indent=2, ensure_ascii=False))
