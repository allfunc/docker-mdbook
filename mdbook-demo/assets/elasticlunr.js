const elasticlunr = window.elasticlunr;

elasticlunr.Index.load = (index) => {
  const FzF = window.fzf.Fzf;
  const store = index.documentStore;
  const arr = [];
  for (i=0,j=store.length; i <j; i++) {
    arr.push(i);
  }
  const ofzf = new FzF(arr, {
    selector:(item)=>{
      const res = index.documentStore.docs[item];
      res.text = `${res.title}${res.breadcrumbs}${res.body}`;
      return res.text;
    }
  })
  return {
    search: (searchterm) => {
      const entries = ofzf.find(searchterm);
      return entries.map(data=>{
        const {item,score} = data;
        return {
          doc: index.documentStore.docs[item],
          ref: item,
          score
        }
      });
    },
  };
};
