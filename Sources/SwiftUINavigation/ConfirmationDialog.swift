#if compiler(>=5.5)
  extension View {
    /// Presents a confirmation dialog from a binding to optional dialog state.
    ///
    /// SwiftUI's `confirmationDialog` view modifiers are driven by two disconnected pieces of
    /// state: an `isPresented` binding to a boolean that determines if the dialog should be
    /// presented, and optional dialog `data` that is used to customize its actions and message.
    ///
    /// Modeling the domain in this way unfortunately introduces a couple invalid runtime states:
    ///
    ///   * `isPresented` can be `true`, but `data` can be `nil`.
    ///   * `isPresented` can be `false`, but `data` can be non-`nil`.
    ///
    /// On top of that, SwiftUI's `confirmationDialog` modifiers take static titles, which means the
    /// title cannot be dynamically computed from the dialog data.
    ///
    /// This overload addresses these shortcomings with a streamlined API. First, it eliminates the
    /// invalid runtime states at compile time by driving the dialog's presentation from a single,
    /// optional binding. When this binding is non-`nil`, the dialog will be presented. Further, the
    /// title can be customized from the dialog data.
    ///
    /// ```swift
    /// struct DialogDemo: View {
    ///   @State var randomMovie: Movie?
    ///
    ///   var body: some View {
    ///     Button("Pick a random movie", action: self.getRandomMovie)
    ///       .confirmationDialog(
    ///         title: { Text($0.title) },
    ///         titleVisibility: .always,
    ///         unwrapping: self.$randomMovie,
    ///         actions: { _ in
    ///           Button("Pick another", action: self.getRandomMovie)
    ///         },
    ///         message: { Text($0.summary) }
    ///       )
    ///   }
    ///
    ///   func getRandomMovie() {
    ///     self.randomMovie = Movie.allCases.randomElement()
    ///   }
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - title: A closure returning the dialog's title given the current dialog state.
    ///   - titleVisibility: The visibility of the dialog's title.
    ///   - value: A binding to an optional value that determines whether a dialog should be
    ///     presented. When the binding is updated with non-`nil` value, it is unwrapped and passed
    ///     to the modifier's closures. You can use this data to populate the fields of a dialog
    ///     that the system displays to the user. When the user presses or taps one of the dialog's
    ///     actions, the system sets this value to `nil` and dismisses the dialog.
    ///   - actions: A view builder returning the dialog's actions given the current dialog state.
    ///   - message: A view builder returning the message for the dialog given the current dialog
    ///     state.
    @available(iOS 15, macOS 12, tvOS 15, watchOS 8, *)
    public func confirmationDialog<Value, A: View, M: View>(
      title: (Value) -> Text,
      titleVisibility: Visibility = .automatic,
      unwrapping value: Binding<Value?>,
      @ViewBuilder actions: (Value) -> A,
      @ViewBuilder message: (Value) -> M
    ) -> some View {
      self.confirmationDialog(
        value.wrappedValue.map(title) ?? Text(""),
        isPresented: value.isPresent(),
        titleVisibility: titleVisibility,
        presenting: value.wrappedValue,
        actions: actions,
        message: message
      )
    }

    /// Presents a confirmation dialog from a binding to an optional enum, and a case path to a
    /// specific case.
    ///
    /// A version of `confirmationDialog(unwrapping:)` that works with enum state.
    ///
    /// - Parameters:
    ///   - title: A closure returning the dialog's title given the current dialog case.
    ///   - titleVisibility: The visibility of the dialog's title.
    ///   - enum: A binding to an optional enum that holds dialog state at a particular case. When
    ///     the binding is updated with a non-`nil` enum, the case path will attempt to extract this
    ///     state and then pass it to the modifier's closures. You can use it to populate the fields
    ///     of a dialog that the system displays to the user. When the user presses or taps one of
    ///     the dialog's actions, the system sets this value to `nil` and dismisses the dialog.
    ///   - casePath: A case path that identifies a particular dialog case to handle.
    ///   - actions: A view builder returning the dialog's actions given the current dialog case.
    ///   - message: A view builder returning the message for the dialog given the current dialog
    ///     case.
    @available(iOS 15, macOS 12, tvOS 15, watchOS 8, *)
    public func confirmationDialog<Enum, Case, A: View, M: View>(
      title: (Case) -> Text,
      titleVisibility: Visibility = .automatic,
      unwrapping enum: Binding<Enum?>,
      case casePath: CasePath<Enum, Case>,
      @ViewBuilder actions: (Case) -> A,
      @ViewBuilder message: (Case) -> M
    ) -> some View {
      self.confirmationDialog(
        title: title,
        titleVisibility: titleVisibility,
        unwrapping: `enum`.case(casePath),
        actions: actions,
        message: message
      )
    }
  }
#endif
