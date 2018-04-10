import React, {Component} from 'react';
import {connect} from 'react-redux';
import {bindActionCreators} from 'redux';
import {fetchWeather} from '../actions';


class SearchBar extends Component {
  constructor(props) {
    super(props);
    this.state = {
      term: ''
    };
  }


  onInputChange(term) {
    this.setState({
      term: term
    });
  }

  onSubmit(event) {
    event.preventDefault();
    this.props.fetchWeather(this.state.term);
    this.setState({term: ''});
  }

  render() {
    const clsName = (this.props.loading) ? 'btn btn-primary loading':'btn btn-primary';
    return(
      <form className="row" onSubmit={event => this.onSubmit(event)}>
        <input 
          className="col-11 form-control" 
          type="text" 
          placeholder="city" 
          value={this.state.term}
          onChange={(event)=>this.onInputChange(event.target.value)}/>
        <button className={clsName} type="submit">
          <i className='fa fa-spinner fa-spin'/>
          Search
        </button>
      </form>
    );
  }
}

function mapStateToProps(state) {
  return {
    loading: state.weathers.loading
  };
}

function mapDispatchToProps(dispatch) {
  return bindActionCreators({fetchWeather}, dispatch);
}

export default connect(mapStateToProps, mapDispatchToProps)(SearchBar);