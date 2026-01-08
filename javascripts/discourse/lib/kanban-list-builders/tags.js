export default function buildTagLists({ kanbanManager, param }) {
  const tags = [];
  if (param) {
    tags.push(...param.split(","));
  } else if (kanbanManager.discoveryTopTags) {
    tags.push(...kanbanManager.discoveryTopTags);
  }

  const tagTranslations = {
    "backlog": "Бэклог",
    "planned": "Планируется",
    "doing": "В работе",
    "done": "Готово"
  };

  const lists = [];

  lists.push(
    ...tags.map((tag) => {
      if (tag === "@untagged") {
        return {
          title: "Untagged",
          params: {
            no_tags: true,
          },
        };
      } else {
        const displayTitle = tagTranslations[tag] || `#${tag}`;
        return {
          title: displayTitle,
          params: {
            tags: [tag],
          },
        };
      }
    })
  );

  return { lists };
}
