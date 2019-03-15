// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

import css from "../css/app.css";
import $ from 'jquery';
import {DateTime, Settings} from 'luxon';
Settings.defaultLocale = 'utc';
const DATETIME_FORMAT = "yyyy-MM-dd'T'hh:mm:ss";

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"

$(() => {
  function getDateTimeLocal(utcSeconds) {
    return DateTime
      .fromMillis(utcSeconds * 1000)
      .toLocal()
      .toFormat(DATETIME_FORMAT);
  }

  $('.link').click(function () {
    window.location = $(this).data('href');
  });

  $('.manage').click(function () {
    const userId = $(this).data('user-id');
    $.ajax(`/api/v1/users/${userId}/manage`, {
      method: 'post'
    }).done(({data: user}) =>
      $(`.user[data-user-id=${user.id}] .user-manager`)
        .text(`Manager: ${user.manager.name || user.manager.email}`));
  });

  $('.toggle-working').click(function () {
    const taskId = $(this).data('task-id');
    if ($(this).data('start')) {
      $.ajax(`/api/v1/tasks/${taskId}/start_working`, {
        method: 'post'
      }).done(() => {
        $(this).data('start', false);
        $(this).text('Stop');
      });
    } else {
      $.ajax(`/api/v1/tasks/${taskId}/stop_working`, {
        method: 'post'
      }).done(() => {
        $(this).text('Start');
        $(this).data('start', true);
      });
    }
  });

  const timeBlocksElement = $('.time-blocks');
  const taskId = timeBlocksElement.data('task-id');
  if (timeBlocksElement[0]) {
    $.ajax(`/api/v1/tasks/${taskId}/time_blocks`, {
      method: 'get'
    }).done(({data}) => {
      const timeBlocks = [];
      for (const timeBlock of data) {
        timeBlocks.push(
          `<div data-tb-id="${timeBlock.id}" class="time-block-form">
             <span class="time-block-inputs">
               From: <input id="start_time" type="datetime-local" value="${getDateTimeLocal(timeBlock.start_time)}"/>
               To: <input id="end_time" type="datetime-local" value="${(timeBlock.end_time && getDateTimeLocal(timeBlock.end_time)) || ''}"/>
             </span>
             <a
              class="btn btn-info btn-xs update"
              data-tb-id="${timeBlock.id}"
             >Update</a>
             <a
               class="btn btn-danger btn-xs delete"
               data-tb-id="${timeBlock.id}"
             >Delete</a>
          </div>`);
      }
      timeBlocksElement.html(timeBlocks.join(''));

      $('.time-block-form .btn.update').click(function() {
        const tbId = $(this).data('tb-id');

        const form = $(`.time-block-form[data-tb-id=${tbId}]`);
        const start = DateTime.fromFormat(
          form.find('input#start_time').val(),
          DATETIME_FORMAT, {
            zone: 'local'
          }).toUTC().toMillis() / 1000;
        const end = DateTime.fromFormat(
          form.find('input#end_time').val(),
          DATETIME_FORMAT, {
            zone: 'local'
          }).toUTC().toMillis() / 1000;
        $.ajax(`/api/v1/tasks/${taskId}/time_blocks/${tbId}`, {
          method: 'patch',
          data: {
            time_block: {
              start_time: start,
              end_time: end
            }
          }
        }).done(({data}) => {
          const form = $(this).closest('.time-block-form');
          form.find('input#start_time').val(getDateTimeLocal(data.start_time))
          form.find('input#end_time').val(getDateTimeLocal(data.end_time))
        });
      });

      $('.time-block-form .btn.delete').click(function() {
        const tbId = $(this).data('tb-id');
        $.ajax(`/api/v1/tasks/${taskId}/time_blocks/${tbId}`, {
          method: 'delete'
        }).done(() =>
          $(this).closest('.time-block-form').remove()
        );
      });
    });
  }
});
