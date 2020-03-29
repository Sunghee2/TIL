# scraping & crawling

- **scraping** : 웹사이트에서 특정 정보만을 추출해서 수집하는 기술
- **crawling** : 웹사이트에서 (주기적으로) 정보를 추출해서 수집하는 기술

<br/>

- beautiful soup : 크롤링 라이브러리

  HTML을 파싱하는데 사용하는 라이브러리로 구문 분석, 트리 탐색, 검색과 수정을 위한 관용구를 이용해 문서를 분석하고 필요한 것을 추출함. 애플리케이션을 작성하는 데 많은 코드가 필요하지 않고, 문서 인코딩을 자동으로 UTF-8로 변환하는 등의 기능이 있음.

- scrapy : 웹 크롤링을 지원하는 프레임워크

  데이터를 추출하는 규칙을 작성하면 나머지는 스크래피를 이용하여 크롤링 처리를 할 수 있음. 구조화되어 있는 데이터를 추출하는데 강점이 있음.

- pandas : 사용하기 쉬운 고성능의 데이터 구조 및 데이터 분석 도구를 제공하는 라이브러리

<br/>

### URL Library

Url을 처리하는 기능 제공

```python
import urllib.request

url = "http://uta.pw/shodou/img/28/214.png"
savename = "test2.png"

# Main memory에 저장
mem = urllib.request.urlopen(url).read()

# 파일로 저장하기  (with block이 끝나면 f를 자동으로 closegka)
# wb: write binary mode
with open(savename, mode = "wb") as f :
    f.write(mem)
    print("저장되었습니다.")
```

<br/>

**decode 주의**

```python
import urllib.request

# 데이터 읽어 들이기
url = "https://www.google.com/"
mem = urllib.request.urlopen(url).read()

# binary를 문자열로 변환하기
print(mem.decode("utf-8"))
```

```python
# IP 확인 API로 접근해서 결과 출력하기
import urllib.request

# 데이터 읽어 들이기
url = "http://api.aoikujira.com/ip/ini"
res = urllib.request.urlopen(url)
data = res.read()

# binary를 문자열로 변환하기
text = data.decode("utf-8")
print(text)
```

<br/>

**Request parameter**

```python
import urllib.request
import urllib.parse
API = "https://search.naver.com/search.naver"
values = {
    "sm" : "top_hty",
    "fbm" : "1",
    "ie": "utf8",
    "query" : "초콜릿"
}
params = urllib.parse.urlencode(values)
url = API + "?" + params
print("url =", url)

data = urllib.request.urlopen(url).read()
text = data.decode("utf-8")
print(text)
```

```python
from bs4 import BeautifulSoup

html = """
<html>
    <body>
        <h1> 스트래핑이란</h1>
        <p> 웹 페이지를 분석해서</p>
        <p> 원하는 부분을 추출하는 기능 </p>
    </body>
</html>
"""

soup  = BeautifulSoup(html, 'html.parser')
# soup.find("h1")
h1 = soup.html.body.h1 
# soup.find("p")
p1 = soup.html.body.p

p2 = p1.next_sibling.next_sibling

print("h1 = " + h1.string)
print("p1 = " + p1.string)
print("p2 = " + p2.string)
```

