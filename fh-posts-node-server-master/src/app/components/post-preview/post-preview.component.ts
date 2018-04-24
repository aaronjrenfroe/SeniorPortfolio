import { PostService } from './../../services/post.service';
import { Component, OnInit, Input, Output, EventEmitter } from '@angular/core';
import * as moment from 'moment';


@Component({
  selector: 'post-preview',
  templateUrl: './post-preview.component.html',
  styleUrls: ['./post-preview.component.css']
})
export class PostPreviewComponent implements OnInit {

  @Input('post') selectedPost;
  @Input() canEdit; 

  @Output('onButtonPress') buttonPressEmmiter = new EventEmitter();

  allEvents = [] 

  constructor(public postService: PostService) {
    postService.getAllEvents((events) => {
      this.allEvents = events
    });
   }

  ngOnInit() {
  }

  getEventNameForID(id){
    let event = this.allEvents.filter((event) =>{
      return event.EventID == id;
    });
    if(event.length > 0){
      return event[0].EventName;
    }
    return 'Unknown event with id: ' + id;
  }

  onButtonPressed(button){
    this.buttonPressEmmiter.emit(button);
  }

  get visibleText(){
    let visibleDate = this.selectedPost.Date_Visable;
    let hasEvents = this.selectedPost.Events.length > 0;
    if (visibleDate != null){
      if(hasEvents){
        if(visibleDate == 0){
          return 'Visible on checkin day';
        }else if(visibleDate > 0){
          if(visibleDate > 1){
            return `Visible ${visibleDate} days after checkin`;
          }
          return `Visible the day after checkin`;
        }else if(visibleDate < 0){
          if(visibleDate < -1){
            return `Visible ${visibleDate* -1} days before checkin`;
          }
          return `Visible the day before checkin`;
        }
      }else if(visibleDate > 0){
        let createdMoment = moment(this.selectedPost.Timestamp);
        let visibleMoment = createdMoment.add(visibleDate,'day');
        let text = createdMoment.from(visibleMoment,true);
        return `Visible ${text} after post was created`;
      }
    }else{
      let createdMoment = moment(this.selectedPost.Timestamp);
      
      return `Visible the day the post was created: ${createdMoment.format('MMM D, YYYY')}`;
    }
  }


}
