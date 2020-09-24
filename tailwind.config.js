module.exports = {
  purge: [
    './app/views/**/*.erb',
  ],
  theme: {
    extend: {
      screens: {
        '2xl': '1440px',
      }
    }
  },
  variants: {
    borderWidth: ['first', 'last'],
    visibility: ['group-hover'],
  },
  plugins: []
}
