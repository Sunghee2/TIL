/*global google*/
import React, {Component} from 'react';

class GoogleMap extends Component {
  constructor(props) {
    super(props);
    this.map = React.createRef();
  }

  componentDidMount() {
    var map = new google.maps.Map(this.map.current, {
      zoom: 12,
      center: {
        lat: this.props.lat,
        lng: this.props.lng
      }
    });
    var marker = new google.maps.Marker({
      position: {
        lat: this.props.lat,
        lng: this.props.lng
      }
    });

    marker.setMap(map);
  }

  render() {
    return(
      <div className="map" ref={this.map}>
      </div>
    );
  }
}

export default GoogleMap;