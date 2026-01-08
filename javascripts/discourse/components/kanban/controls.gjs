import Component from "@glimmer/component";
import { action } from "@ember/object";
import { service } from "@ember/service";
import DButton from "discourse/components/d-button";
import bodyClass from "discourse/helpers/body-class";
import { i18n } from "discourse-i18n";
import DMenu from "float-kit/components/d-menu";
import CopyLinkButton from "./copy-link-button";
// Импорт модалки больше не нужен, раз мы убрали кнопку
// import KanbanOptionsModal from "./modal/options"; 

export default class KanbanControls extends Component {
  @service modal;
  @service kanbanManager;

  @action
  toggleFullscreen() {
    this.kanbanManager.fullscreen = !this.kanbanManager.fullscreen;
  }

  // Метод openSettings можно удалить, так как кнопки больше нет
  
  <template>
    {{#if this.kanbanManager.active}}
      <DMenu
        class="kanban-controls"
        @icon="far-rectangle-list"
        @title={{i18n (themePrefix "controls")}}
        as |menu|
      >
        <ul class="kanban-controls">
          {{!-- 
             МЫ ПОЛНОСТЬЮ УДАЛИЛИ КНОПКУ НАСТРОЕК ОТСЮДА.
             Теперь пользователь физически не может открыть настройки.
          --}}
          
          <li>
            <CopyLinkButton />
          </li>
          <li>
            <DButton
              @icon={{if
                this.kanbanManager.fullscreen
                "discourse-compress"
                "discourse-expand"
              }}
              class="btn-transparent"
              @action={{this.toggleFullscreen}}
              @label={{themePrefix "fullscreen"}}
            />
          </li>
        </ul>
      </DMenu>

      {{#if this.kanbanManager.fullscreen}}
        {{bodyClass "kanban-fullscreen"}}
      {{/if}}
    {{/if}}
  </template>
}
