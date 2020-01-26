describe('It opens', function () {
  it('works', function () {
    cy.viewport(400, 500)
    cy.fixture('vote.json').then((json) => {
      console.log(json)
      cy.loadInitialState(JSON.stringify(json))
    })
  })
})