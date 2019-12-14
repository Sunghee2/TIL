###  Perceptron

![퍼셉트론](https://cdn-images-1.medium.com/max/1600/1*Fyapb-JRFJ-VtnLYLLXCwg.png)

복수의 입력 신호 각각에 고유한 가중치(w)를 부여함(가중치가 클수록 결과에 큰 영향을 미치므로 중요도를 나타냄)

그림의 우측 상단 식을 보면 뉴런에서 보내온 신호의 총합이 정해진 한계(임계값 theta)을 넘어설 때만 1을 출력하게 됨

>위 사진에서 바꿀 수 있는 매개변수는 w1, w2, …, theta임.
>
>여기서 AND게이트를 만든다고 하고 입력은 2개라고 가정하면 변수을 1.0, 1.0, 1.0(w1, w2, theta)으로 설정하면 됨.
>
>![img](https://wikidocs.net/images/page/24958/and%EA%B7%B8%EB%9E%98%ED%94%84%EC%99%80%EA%B2%8C%EC%9D%B4%ED%8A%B8%EC%8B%9C%EA%B0%81%ED%99%94.PNG)

그림의 우측 상단의 식을 하단의 식으로 수정할 수 있음. 

theta -> -b로 치환할 때, 이 b를 *bias*라고 함. 

bias : 뉴런이 얼마나 쉽게 활성화(결과로 1을 출력)하느냐를 조정하는 매개변수

<br/>

**perceptron의 한계**

지금까지의 perceptron으로는 XOR게이트를 구현할 수 없음.

왜? 위의 and gate는 직선으로 점을 나눌 수 있지만(선형) xor gate는 곡선(비선형)으로 나눌 수 있다.

![xor gate](https://wikidocs.net/images/page/24958/xor%EA%B2%8C%EC%9D%B4%ED%8A%B8%EB%B9%84%EC%84%A0%ED%98%95.PNG)

<br/>

**multi-layer perceptron(MLP)**

위에서 불가능한 xor gate는 기존의 and, nand, or gate를 조합하면 만들 수 있음. 

즉, 층을 깊게 하여 다양한 것을 표현할 수 있는 것!

![img](https://wikidocs.net/images/page/24958/mlp_%EC%88%98%EC%A0%95.PNG)

<br/>

### Neural Network

**activation function** : 입력 신호의 총합을 출력 신호로 변환하는 함수

아래 그림과 같이 node2에서 가중치*입력신호들과 편향(아래 그림에는 없음)의 총합을 계산함 => 이 계산 값을 함수 f()에 넣어 결과를 출력하는 흐름. 

![activation function](https://theffork.com/wp-content/uploads/2019/02/InsideAF.png)

activation function은 비선형 함수이어야됨. 

왜? 선형함수라면 층을 깊게 하는 의미가 없음. 맨 위의 단층 퍼셉트론 처럼 은닉층 없는 네트워크로도 똑같은 기능을 할 수 있기 때문. 

1. Step function

   ![step function](https://wikidocs.net/images/page/24987/step_function.PNG)

2. Sigmoid function 

   ![sigmoid function](https://wikidocs.net/images/page/24987/%EC%8B%9C%EA%B7%B8%EB%AA%A8%EC%9D%B4%EB%93%9C_%ED%95%A8%EC%88%98.PNG)

   binary classification에 자주 쓰임(0, 1 사이의 값을 반환하기 때문) ex) 스팸 메일 분류

   왜 step이 아니라 sigmoid? step은 0을 경계로 급격하게 변하지만 sigmoid는 연속적으로 변하는 곡선의 모양을 가짐 

3. Relu function

   ![img](https://wikidocs.net/images/page/24987/%EB%A0%90%EB%A3%A8%ED%95%A8%EC%88%98.PNG)

4. Tanh function

   ![img](https://wikidocs.net/images/page/24987/%ED%95%98%EC%9D%B4%ED%8D%BC%EB%B3%BC%EB%A6%AD_%ED%83%84%EC%A0%A0%ED%8A%B8.PNG)

5. Softmax function

   ![img](https://wikidocs.net/images/page/24987/%EC%86%8C%ED%94%84%ED%8A%B8%EB%A7%A5%EC%8A%A4_%ED%95%A8%EC%88%98.PNG)

   multiclass classification에 주로 사용됨

   

batch : 여러 데이터를 묶어서 처리
수치계산 라이브러리 대부분이 큰 배열을 효율적으로 처리할 수 있도록 최적화 되어있어 처리 시간이 줄음.

mini-batch : 트레이닝 데이터 중 일부만 골라 학습 수행

<br/>

### 신경망 학습

학습 : 트레이닝 데이터로부터 가중치 매개변수의 최적값을 자동으로 획득하는 것

1. 미니배치 
2. 기울기 산출 : 각 가중치 매개변수의 기울기를 구함(기울기는 loss function 값을 가장 작게 하는 방향을 제시)
3. 매개변수 갱신 : 가중치 매개변수를 기울기 방향으로 조금 갱신

**loss function**

> 정확도를 왜 지표로 삼으면 안될까?
>
> 만약 100장의 트레이닝 데이터 중 32장을 올바로 인식한다면 정확도는 32%임.
>
> 만약 매개변수의 값을 조금 바꿨는데 아직도 32장을 인식한다면 정확도는 여전히 32%임.
>
> 정확도가 개선된다 하더라도 그 값은 32.234%같은 연속적인 변화보다는 33%, 34% 같은 띄엄띄엄한 값으로 바뀌어버림(계단 함수와 비슷한 원리)

1.  MSE(mean squared error)

   ![mse formula](https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRGYwFcZe2dvzipzztfuI6Tu80AS5LImJsuUjhLFnIya0-eF_Bn)

   > y = 신경망이 추정한 값
   >
   > t = 정답 레이블
   >
   > i = 차원 수

2. CEE(cross entropy error)

   - 데이터가 1개인 경우

     ![cee formula](https://t1.daumcdn.net/cfile/tistory/99C0D73B5A92769625)

     > y = 신경망이 추정한 값
     >
     > t = 정답 레이블

   - 데이터가 N개

     ![cross entropy error formula](https://i.stack.imgur.com/GKdbq.png)

     > i번째 데이터의 j번째 값
     >
     > 나머지는 위와 동일



<br/>

### back propagation





   