#import "@preview/scienceicons:0.1.0": orcid-icon

#let resume(
  author: "",
  author-position: left,
  personal-info-position: left,
  pronouns: "",
  location: "",
  email: "",
  github-personal: "",
  github-cmu: "",
  linkedin: "",
  phone: "",
  personal-site: "",
  orcid: "",
  accent-color: "#000000",
  font: "New Computer Modern",
  paper: "us-letter",
  author-font-size: 20pt,
  font-size: 10pt,
  section-title-padding-top: 0pt,
  section-title-padding-bottom: -10pt,
  personal-info-padding-top: 0.25em,
  body,
) = {

  // Sets document metadata
  set document(author: author, title: author)

  // Document-wide formatting, including font and margins
  set text(
    // LaTeX style font
    font: font,
    size: font-size,
    lang: "en",
    // Disable ligatures so ATS systems do not get confused when parsing fonts.
    ligatures: false
  )

  // Reccomended to have 0.5in margin on all sides
  set page(
    margin: (0.5in),
    paper: paper,
  )

  // Link styles
  show link: underline


  // Small caps for section titles
  show heading.where(level: 2): it => [
    #pad(top: section-title-padding-top, bottom: section-title-padding-bottom, [#smallcaps(it.body)])
    #line(length: 100%, stroke: 1pt)
  ]

  // Accent Color Styling
  show heading: set text(
    fill: rgb(accent-color),
  )

  show link: set text(
    fill: rgb(accent-color),
  )

  // Name will be aligned left, bold and big
  show heading.where(level: 1): it => [
    #set align(author-position)
    #set text(
      weight: 700,
      size: author-font-size,
    )
    #pad(it.body)
  ]

  // Level 1 Heading
  [= #(author)]

  // Personal Info Helper
  let contact-item(value, prefix: "", link-type: "", display: "") = {
    if value == "" {
      return
    }

    if link-type == "" {
      return value
    }

    if display == "" {
      link(link-type + value)[#(prefix + value)]
    } else {
      link(link-type + value)[#display]
    }
  }

  // Personal Info
  pad(
    top: personal-info-padding-top,
    align(personal-info-position)[
      #{
        let items = (
          contact-item(pronouns),
          contact-item(phone),
          contact-item(location),
          contact-item(email, link-type: "mailto:"),
          contact-item(github-personal, link-type: "https://", display: "Personal GitHub"),
          contact-item(github-cmu, link-type: "https://", display: "CMU GitHub"),
          contact-item(linkedin, link-type: "https://", display: "LinkedIn"),
          contact-item(personal-site, link-type: "https://", display: "Portfolio"),
          contact-item(orcid, prefix: [#orcid-icon(color: rgb("#AECD54"))orcid.org/], link-type: "https://orcid.org/"),
        )
        items.filter(x => x != none).join("  |  ")
      }
    ],
  )

  // Main body.
  set par(justify: true)

  body
}

// Generic two by two component for resume
#let generic-two-by-two(
  top-left: "",
  top-right: "",
  bottom-left: "",
  bottom-right: "",
) = {
  [
    #top-left #h(1fr) #top-right \
    #bottom-left #h(1fr) #bottom-right
  ]
}

// Generic one by two component for resume
#let generic-one-by-two(
  left: "",
  right: "",
) = {
  [
    #left #h(1fr) #right
  ]
}

// Cannot just use normal --- ligature becuase ligatures are disabled for good reasons
#let dates-helper(
  start-date: "",
  end-date: "",
) = {
  start-date + " " + $dash.em$ + " " + end-date
}

// Section components below
#let edu(
  institution: "",
  dates: "",
  degree: "",
  gpa: "",
  location: "",
  // Makes dates on upper right like rest of components
  consistent: false,
) = {
  if consistent {
    // edu-constant style (dates top-right, location bottom-right)
    generic-two-by-two(
      top-left: strong(institution),
      top-right: dates,
      bottom-left: emph(degree),
      bottom-right: emph(location),
    )
  } else {
    // original edu style (location top-right, dates bottom-right)
    generic-two-by-two(
      top-left: strong(institution),
      top-right: location,
      bottom-left: emph(degree),
      bottom-right: emph(dates),
    )
  }
}

#let work(
  title: "",
  dates: "",
  company: "",
  location: "",
) = {
  generic-two-by-two(
    top-left: strong(title),
    top-right: dates,
    bottom-left: company,
    bottom-right: emph(location),
  )
}

#let project(
  role: "",
  name: "",
  url: "",
  dates: "",
  display-url: true
) = {
  let link-text = if display-url {
    url
  } else {
    "Link"
  }

  generic-one-by-two(
    left: {
      if role == "" {
        [*#name* #if url != "" and dates != "" [(#link("https://" + url)[#link-text])]]
      } else {
        [*#role*, #name #if url != "" and dates != "" [(#link("https://" + url)[#link-text])]]
      }
    },
    right: {
      if dates == "" and url != "" {
        link("https://" + url)[#link-text]
      } else {
        dates
      }
    },
  )
}

#let certificates(
  name: "",
  issuer: "",
  url: "",
  date: "",
  display-url: true
) = {
  let link-text = if display-url {
    url
  } else {
    "Link"
  }

  [
    *#name*, #issuer
    #if url != "" {
      [ (#link("https://" + url)[#link-text])]
    }
    #h(1fr) #date
  ]
}

#let extracurriculars(
  activity: "",
  dates: "",
) = {
  generic-one-by-two(
    left: strong(activity),
    right: dates,
  )
}
