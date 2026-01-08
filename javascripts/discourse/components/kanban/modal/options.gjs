import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { fn, hash } from "@ember/helper";
import { action } from "@ember/object";
import { equal } from "@ember/object/computed";
import { service } from "@ember/service";
import DButton from "discourse/components/d-button";
import DModal from "discourse/components/d-modal";
import DiscourseURL from "discourse/lib/url";
import { i18n } from "discourse-i18n";
// ComboBox больше не нужен, мы удалили выбор режима
// import ComboBox from "select-kit/components/combo-box"; 
import EmailGroupUserChooser from "select-kit/components/email-group-user-chooser";
import MultiSelect from "select-kit/components/multi-select";
import TagChooser from "select-kit/components/tag-chooser";

export default class KanbanOptionsController extends Component {
  @service kanbanManager;
  @service site;

  @tracked tags = [];
  @tracked usernames = [];
  @tracked categories = [];
  
  // ПРИНУДИТЕЛЬНО СТАВИМ TAGS
  @tracked mode = "tags"; 

  // Этот массив можно удалить, так как выбор мы скрываем, но можно и оставить, чтобы не ломать старые ссылки
  modes = [{ id: "tags" }, { id: "categories" }, { id: "assigned" }];

  @equal("mode", "tags") isTags;
  @equal("mode", "categories") isCategories;
  @equal("mode", "assigned") isAssigned;

  constructor() {
    super(...arguments);
    const [currentMode, params] = this.kanbanManager.resolvedDescriptorParts;

    // ЛОГИКА ИЗМЕНЕНА:
    // Мы игнорируем currentMode, который пришел из URL, и всегда работаем в режиме tags.
    // Если раньше были выбраны теги, подгружаем их. Если нет — список пуст.
    this.mode = "tags"; 

    if (currentMode === "tags") {
      this.tags = params?.split(",") || [];
    } else {
      // Если пользователь пришел с доски категорий, сбрасываем теги в пустой массив
      this.tags = [];
    }
    
    // Остальные параметры можно не инициализировать, так как мы запрещаем переключение
    this.categories = [];
    this.usernames = [];
  }

  @action
  apply() {
    let descriptor = "";
    
    // Так как this.mode жестко задан как "tags", сработает только этот блок
    if (this.isTags) {
      descriptor += "tags";
      if (this.tags.length > 0) {
        descriptor += `:${this.tags.join(",")}`;
      }
    } 
    // Блоки else if для категорий и assigned технически не сработают, 
    // но их можно оставить на всякий случай или удалить для чистоты кода.

    let href = this.kanbanManager.getBoardUrl({
      category: this.kanbanManager.discoveryCategory,
      tag: this.kanbanManager.discoveryTag,
      descriptor,
    });

    this.args.closeModal();
    DiscourseURL.routeTo(href, { replaceURL: true });
  }

  <template>
    <DModal
      class="kanban-modal"
      @title={{i18n (themePrefix "modal.title")}}
      @closeModal={{@closeModal}}
    >
      <:body>
        {{!-- 
            УДАЛЕНО: Блок выбора режима (ComboBox). 
            Теперь пользователь не видит выпадающий список "Mode".
        --}}

        <div class="control-group">
          {{!-- Меняем лейбл, так как выбора списков нет, есть только выбор тегов --}}
          <label>{{i18n (themePrefix "modal.lists")}} (Tags)</label>
          
          {{!-- 
            Так как isTags всегда true, рендерим только TagChooser.
            Остальные условия (MultiSelect, EmailGroupUserChooser) никогда не покажутся.
          --}}
          
          <TagChooser
            @tags={{this.tags}}
            @allowCreate={{false}}
            @everyTag={{true}}
            @options={{hash
              filterPlaceholder=(themePrefix "modal.tags_placeholder")
            }}
            @unlimitedTagCount={{true}}
            class="kanban-tag-chooser"
          />
        </div>
      </:body>
      <:footer>
        <DButton
          class="btn-primary"
          @action={{this.apply}}
          @label={{themePrefix "modal.apply"}}
        />
      </:footer>
    </DModal>
  </template>
}
