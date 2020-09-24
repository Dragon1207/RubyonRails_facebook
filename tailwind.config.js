module.exports = {
  purge: [
    './app/views/**/*.erb',
  ],
  theme: {
    extend: {}
  },
  variants: {
    borderWidth: ['first', 'last'],
    visibility: ['group-hover'],
  },
  plugins: []
}
