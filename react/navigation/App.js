import React from 'react';
import { 
  StyleSheet, Text, View, Button, Image,
  ActivityIndicator,
  AsyncStorage,
  StatusBar
} from 'react-native';
import { 
  createStackNavigator, 
  createSwitchNavigator,
  createBottomTabNavigator, 
  TabNavigator, 
  TabBarBottom 
} from 'react-navigation'; 
import { Ionicons } from '@expo/vector-icons';

class SignInScreen extends React.Component {
  static navigationOptions = {
    title: 'Please sign in',
  };

  render() {
    return (
      <View style={styles.container}>
        <Button title="Sign in!" onPress={this._signInAsync} />
      </View>
    );
  }

  _signInAsync = async () => {
    await AsyncStorage.setItem('userToken', 'abc');
    this.props.navigation.navigate('App');
  };
}

class HomeScreen extends React.Component {
  static navigationOptions = {
    title: 'Welcome to the app!',
  };

  render() {
    return (
      <View style={styles.container}>
        <Button title="Show me more of the app" onPress={this._showMoreApp} />
        <Button title="Actually, sign me out :)" onPress={this._signOutAsync} />
      </View>
    );
  }

  _showMoreApp = () => {
    this.props.navigation.navigate('Other');
  };

  _signOutAsync = async () => {
    await AsyncStorage.clear();
    this.props.navigation.navigate('Auth');
  };
}

class OtherScreen extends React.Component {
  static navigationOptions = {
    title: 'Lots of features here',
  };

  render() {
    return (
      <View style={styles.container}>
        <Button title="I'm done, sign me out" onPress={this._signOutAsync} />
        <StatusBar barStyle="default" />
      </View>
    );
  }

  _signOutAsync = async () => {
    await AsyncStorage.clear();
    this.props.navigation.navigate('Auth');
  };
}

class AuthLoadingScreen extends React.Component {
  constructor() {
    super();
    this._bootstrapAsync();
  }

  // Fetch the token from storage then navigate to our appropriate place
  _bootstrapAsync = async () => {
    const userToken = await AsyncStorage.getItem('userToken');

    // This will switch to the App screen or Auth screen and this loading
    // screen will be unmounted and thrown away.
    this.props.navigation.navigate(userToken ? 'App' : 'Auth');
  };

  // Render any loading content that you like here
  render() {
    return (
      <View style={styles.container}>
        <ActivityIndicator />
        <StatusBar barStyle="default" />
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
});

const AppStack = createStackNavigator({ Home: HomeScreen, Other: OtherScreen });
const AuthStack = createStackNavigator({ SignIn: SignInScreen });

export default createSwitchNavigator(
  {
    AuthLoading: AuthLoadingScreen,
    App: AppStack,
    Auth: AuthStack,
  },
  {
    initialRouteName: 'AuthLoading',
  }
);

// class LogoTitle extends React.Component {
//   render() {
//     return (
//       <Image
//         source={require('./4.png')}
//         style={{ width: 30, height: 30 }}
//       />
//     );
//   }
// }

// class HomeScreen extends React.Component {
//   static navigationOptions = ({ navigation }) => {
//     const params = navigation.state.params || {};

//     return {
//       headerTitle: <LogoTitle />,
//       headerLeft: (
//         <Button
//           onPress={() => navigation.navigate('MyModal')}
//           title="Info"
//           color="#fff"
//         />
//       ),
//       headerRight: (
//         <Button onPress={params.increaseCount} title="+1" color="#fff" />
//       ),
//     };
//   };

//   componentWillMount() {
//     this.props.navigation.setParams({ increaseCount: this._increaseCount });
//   }

//   state = {
//     count: 0,
//   };

//   _increaseCount = () => {
//     this.setState({ count: this.state.count + 1 });
//   };

//   render() {
//     return (
//       <View style={{flex:1, alignItems: 'center', justifyContent: 'center'}}>
//         <Text>Home Screen</Text>
//         <Text>Count: {this.state.count}</Text>
//         <Button
//           title="Go to Details"
//           onPress={()=>this.props.navigation.navigate('Details', {
//             itemId: 86,
//             otherParam: 'anything you want here',          
//           })}
//         />
//         <Button
//           title="Go to Settings"
//           onPress={() => this.props.navigation.navigate('Settings')}
//         />
//       </View>
//     );
//   }
// }

// class DetailsScreen extends React.Component {
//   static navigationOptions = ({navigation, navigationOptions }) => {
//     const { params } = navigation.state;

//     return {
//       title: params ? params.otherParam : 'A Nested Details Screen',
//       headerStyle: {
//         backgroundColor: navigationOptions.headerTintColor,
//       },
//       headerTintColor: navigationOptions.headerStyle.backgroundColor,
//     }
//   };
  
//   render() {
//     const { navigation } = this.props;
//     const itemId = navigation.getParam('itemId', 'NO-ID');
//     const otherParam = navigation.getParam('otherParam', 'some default value');
    
//     return (
//       <View style={{ flex: 1, alignItems: 'center', justifyContent: 'center' }}>
//         <Text>Details Screen</Text>
//         <Text>itemId: {itemId}</Text>
//         <Text>otherParam: {otherParam}</Text>
//         <Button
//           title="Go to Details... again"
//           onPress={() => this.props.navigation.push('Details', {
//             itemId: Math.floor(Math.random()*100),
//           })}
//         />
//         <Button
//           title="Go to Home"
//           onPress={() => this.props.navigation.navigate('Home')}
//         />
//         <Button
//           title="Go back"
//           onPress={() => this.props.navigation.goBack()}
//         />
//         <Button
//           title="Update the title"
//           onPress={() => this.props.navigation.setParams({otherParam: 'Updated!'})}
//         />
//       </View>
//     );
//   }
// }

// class ModalScreen extends React.Component {
//   render() {
//     return (
//       <View style={{ flex: 1, alignItems: 'center', justifyContent: 'center' }}>
//         <Text style={{ fontSize: 30 }}>This is a modal!</Text>
//         <Button
//           onPress={() => this.props.navigation.goBack()}
//           title="Dismiss"
//         />
//       </View>
//     );
//   }
// }

// class SettingsScreen extends React.Component {
//   render() {
//     return (
//       <View style={{ flex: 1, justifyContent: 'center', alignItems: 'center' }}>
//         <Text>Settings!</Text>
//         <Button
//           title="Go to Home"
//           onPress={() => this.props.navigation.navigate('Home')}
//         />
//         <Button
//           title="Go to Details"
//           onPress={() => this.props.navigation.navigate('Details')}
//         />
//       </View>
//     );
//   }
// }

// const MainStack = createStackNavigator(
//   {
//     Home: {
//       screen: HomeScreen,
//     },
//     Details: {
//       screen: DetailsScreen,
//     },
//   },
//   {
//     initialRouteName: 'Home', 
//     navigationOptions: {
//       headerStyle: {
//         backgroundColor: '#f4511e',
//       },
//       headerTintColor: '#fff',
//       headerTitleStyle: {
//         fontWeight: 'bold',
//       },
//     },
//   }
// );

// const RootStack = createStackNavigator(
//   {
//     Main: {
//       screen: MainStack,
//     },
//     MyModal: {
//       screen: ModalScreen,
//     },
//   },
//   {
//     mode: 'modal',
//     headerMode: 'none',
//   }
// );

// // export default class App extends React.Component {
// //   render() {
// //     return <RootStack />;
// //   }
// // }

// // export default createBottomTabNavigator({
// //   Home: HomeScreen,
// //   Settings: SettingsScreen,
// // });

// const HomeStack = createStackNavigator({
//   Home: { screen: HomeScreen },
//   Details: { screen: DetailsScreen },
// });

// const SettingsStack = createStackNavigator({
//   Settings: { screen: SettingsScreen },
//   Details: { screen: DetailsScreen },
// });


// export default TabNavigator(
//   {
//     Home: { screen: HomeStack },
//     Settings: { screen: SettingsStack },
//   },
//   {
//     navigationOptions: ({ navigation }) => ({
//       tabBarIcon: ({ focused, tintColor }) => {
//         const { routeName } = navigation.state;
//         let iconName;
//         if (routeName === 'Home') {
//           iconName = `ios-information-circle${focused ? '' : '-outline'}`;
//         } else if (routeName === 'Settings') {
//           iconName = `ios-options${focused ? '' : '-outline'}`;
//         }

//         // You can return any component that you like here! We usually use an
//         // icon component from react-native-vector-icons
//         return <Ionicons name={iconName} size={25} color={tintColor} />;
//       },
//     }),
//     tabBarComponent: TabBarBottom,
//     tabBarPosition: 'bottom',
//     tabBarOptions: {
//       activeTintColor: 'tomato',
//       inactiveTintColor: 'gray',
//     },
//     animationEnabled: false,
//     swipeEnabled: false,
//   }
// );
