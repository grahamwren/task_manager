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
});
