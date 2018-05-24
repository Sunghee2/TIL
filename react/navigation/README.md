  - #### https://reactnavigation.org/docs/en/navigating.html

    - `navigation.popToTop()` -> 스택의 첫 번째 화면으로 돌아감
    - `navigate('RouteName')` -> 스택에 없는 경로를 푸시함(stackNavigator에 있는 경로여야 함)
    - `navigate('RouteName', { /* params go here */ })` -> navigate의 두 번째 매개 변수를 넣어 경로에 전달함. 
    - `this.props.navigation.getParam(paramName, defaultValue)` -> 매개 변수를 읽음
    
    ``` 
    const { navigation } = this.props;
    static navigationOptions = ({navigation}) => {
        const { params } = navigation.state;
    ```
    - navigation을 통해 매개 변수 가져올 수 있음

> https://github.com/vonovak/react-navigation-header-buttons




