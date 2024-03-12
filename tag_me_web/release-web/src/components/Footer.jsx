import React from "react";
import styled from "styled-components";

const FooterTagMe = styled.footer`
  margin: 2rem 0;
  text-align: center;
  font-size: 14px;
  padding: 1rem;
  background-color: #f8f9fa; /* Light gray color */
  color: #555; /* Dark gray color */

  a {
    color: #007bff; /* Blue color for links */
    text-decoration: none;
    font-weight: bold;
  }

  @media (min-width: 1100px) {
    margin: 6rem 0 0 0;
  }
`;

export default function Footer() {
  return (
    <FooterTagMe>
      <p>
        &copy; {new Date().getFullYear()} Tag Me. All rights reserved. {" "}
        <div to="/privacy">Privacy Policy</div> {" "}
        <div to="/terms">Terms of Service</div>
      </p>
    </FooterTagMe>
  );
}
