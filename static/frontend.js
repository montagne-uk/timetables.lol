const {
    onMounted,
    onUpdated,
    onUnmounted,
  } = Vue;
  //Define Vue app
  const App = {
    data() {
      return {
        message: 'Hello, Vue!'
      };
    },
    methods: {
    },
    setup(props, context) {
      onMounted(() => {
        console.info("App mounted!");
      });
      onUpdated(() => {
        console.info("App updated!");
      });
      onUnmounted(() => {
        console.info("App unmounted!");
      });
    }
  };

  const app = Vue.createApp(App);
  app.mount("#vue");
  