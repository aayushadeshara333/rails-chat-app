import e, {
  SubscribingElement as t
} from "cable_ready";
customElements.define("cubicle-element", class extends t {
  constructor() {
    super();
    this.attachShadow({
      mode: "open"
    }).innerHTML = "\n<style>\n  :host {\n    display: block;\n  }\n</style>\n<slot></slot>\n", this.triggerRoot = this, this.present = !1
  }
  async connectedCallback() {
    this.preview || (this.appear = function (e, t) {
      let r;
      return (...i) => {
        clearTimeout(r), r = setTimeout((() => e.apply(this, i)), t)
      }
    }(this.appear.bind(this), 50), this.appearTriggers = this.getAttribute("appear-trigger") ? this.getAttribute("appear-trigger").split(",") : [], this.disappearTriggers = this.getAttribute("disappear-trigger") ? this.getAttribute("disappear-trigger").split(",") : [], this.triggerRootSelector = this.getAttribute("trigger-root"), this.consumer = await e.consumer, this.channel = this.createSubscription(), this.appearanceIntersectionObserver = new IntersectionObserver(((e, t) => {
      e.forEach((e => {
        e.target === this.triggerRoot && (e.isIntersecting ? this.present || this.appear() : this.present && this.disappear())
      }))
    }), {
      threshold: 0
    }), this.mutationObserver = new MutationObserver(((e, t) => {
      if (this.triggerRootSelector)
        for (const t of e) {
          const e = document.querySelector(this.triggerRootSelector);
          e && (this.uninstall(), this.triggerRoot = e, this.install())
        }
      this.mutationObserver.disconnect()
    })), this.mutationObserver.observe(document, {
      subtree: !0,
      childList: !0
    }))
  }
  disconnectedCallback() {
    this.disappear(), super.disconnectedCallback()
  }
  install() {
    this.appearTriggers.includes("connect") && this.appear(), this.appearTriggers.filter((e => "intersect" === e)).forEach((() => {
      this.appearanceIntersectionObserver.observe(this.triggerRoot)
    })), this.appearTriggers.filter((e => "connect" !== e && "intersect" !== e)).forEach((e => {
      this.triggerRoot.addEventListener(e, this.appear.bind(this))
    })), this.disappearTriggers.filter((e => "disconnect" !== e && "intersect" !== e)).forEach((e => {
      this.triggerRoot.addEventListener(e, this.disappear.bind(this))
    })), this.disappearTriggers.filter((e => "intersect" === e)).forEach((() => { }))
  }
  uninstall() {
    this.appearTriggers.filter((e => "intersect" === e)).forEach((() => {
      this.appearanceIntersectionObserver.unobserve(this.triggerRoot)
    })), this.appearTriggers.filter((e => "connect" !== e && "intersect" !== e)).forEach((e => {
      this.triggerRoot.removeEventListener(e, this.appear.bind(this))
    })), this.disappearTriggers.filter((e => "intersect" === e)).forEach((() => { })), this.disappearTriggers.filter((e => "disconnect" !== e && "intersect" !== e)).forEach((e => {
      this.triggerRoot.removeEventListener(e, this.disappear.bind(this))
    }))
  }
  appear() {
    this.channel && (this.present = !0, this.channel.perform("appear"))
  }
  disappear() {
    this.channel && (this.present = !1, this.channel.perform("disappear"))
  }
  performOperations(t) {
    t.cableReady && e.perform(t.operations)
  }
  createSubscription() {
    if (this.consumer) return this.consumer.subscriptions.create({
      channel: this.channelName,
      identifier: this.getAttribute("identifier"),
      element_id: this.id,
      scope: this.getAttribute("scope"),
      exclude_current_user: "true" === this.getAttribute("exclude-current-user")
    }, {
      connected: () => {
        this.install()
      },
      disconnected: () => {
        this.disappear(), this.uninstall()
      },
      rejected: () => {
        this.uninstall()
      },
      received: this.performOperations.bind(this)
    });
    console.error("The `cubicle-element` helper cannot connect without an ActionCable consumer.")
  }
  get channelName() {
    return "Cubism::PresenceChannel"
  }
});

//# sourceMappingURL=cubism.min.js.map